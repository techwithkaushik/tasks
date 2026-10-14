import { readFile } from 'node:fs/promises';
import { after, before, beforeEach, test } from 'node:test';
import assert from 'node:assert/strict';
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  collection,
  deleteDoc,
  doc,
  getDoc,
  getDocs,
  query,
  setDoc,
  updateDoc,
  where,
} from 'firebase/firestore';

const projectId = 'demo-tasks-rules';
let testEnv;

before(async () => {
  const rules = await readFile(new URL('../firestore.rules', import.meta.url), 'utf8');
  testEnv = await initializeTestEnvironment({
    projectId,
    firestore: { rules },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.withSecurityRulesDisabled(async (context) => {
    const db = context.firestore();
    await setDoc(doc(db, 'tasks', 'alice-task'), {
      userId: 'alice',
      title: 'Alice task',
      status: 'pending',
    });
    await setDoc(doc(db, 'tasks', 'bob-task'), {
      userId: 'bob',
      title: 'Bob task',
      status: 'pending',
    });
    await setDoc(doc(db, 'privateProfiles', 'alice'), { name: 'Alice' });
  });
});

after(async () => {
  await testEnv?.cleanup();
});

test('authenticated owner can read their own task', async () => {
  const db = testEnv.authenticatedContext('alice').firestore();
  await assertSucceeds(getDoc(doc(db, 'tasks', 'alice-task')));
});

test('a user cannot read another user task by document ID', async () => {
  const db = testEnv.authenticatedContext('alice').firestore();
  await assertFails(getDoc(doc(db, 'tasks', 'bob-task')));
});

test('owner-scoped task query succeeds and cross-user query is denied', async () => {
  const db = testEnv.authenticatedContext('alice').firestore();
  await assertSucceeds(getDocs(query(collection(db, 'tasks'), where('userId', '==', 'alice'))));
  await assertFails(getDocs(query(collection(db, 'tasks'), where('userId', '==', 'bob'))));
});

test('users can create tasks only for themselves', async () => {
  const db = testEnv.authenticatedContext('alice').firestore();
  await assertSucceeds(setDoc(doc(db, 'tasks', 'alice-new'), {
    userId: 'alice',
    title: 'New task',
  }));
  await assertFails(setDoc(doc(db, 'tasks', 'spoofed'), {
    userId: 'bob',
    title: 'Spoofed task',
  }));
});

test('owner can update task fields but cannot transfer ownership', async () => {
  const db = testEnv.authenticatedContext('alice').firestore();
  await assertSucceeds(updateDoc(doc(db, 'tasks', 'alice-task'), { title: 'Updated title' }));
  await assertFails(updateDoc(doc(db, 'tasks', 'alice-task'), { userId: 'bob' }));
});

test('owner can delete own task but cannot delete another user task', async () => {
  const db = testEnv.authenticatedContext('alice').firestore();
  await assertSucceeds(deleteDoc(doc(db, 'tasks', 'alice-task')));
  await assertFails(deleteDoc(doc(db, 'tasks', 'bob-task')));
});

test('unauthenticated clients cannot read or write tasks', async () => {
  const db = testEnv.unauthenticatedContext().firestore();
  await assertFails(getDoc(doc(db, 'tasks', 'alice-task')));
  await assertFails(setDoc(doc(db, 'tasks', 'anonymous'), { userId: 'anonymous' }));
  await assertFails(updateDoc(doc(db, 'tasks', 'alice-task'), { title: 'Unauthorized' }));
  await assertFails(deleteDoc(doc(db, 'tasks', 'alice-task')));
});

test('collections outside the explicit task rule remain denied', async () => {
  const db = testEnv.authenticatedContext('alice').firestore();
  await assertFails(getDoc(doc(db, 'privateProfiles', 'alice')));
  await assertFails(setDoc(doc(db, 'privateProfiles', 'new-profile'), { name: 'New' }));
});
