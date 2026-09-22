import { getAdminDb } from "../firebase/server";
import { COLLECTIONS } from "../firebase/constants";

export async function getFeedbackCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.REVIEWS).count().get();
  return snapshot.data().count;
}

export async function getReviewsSnapshot(limitCount: number = 10) {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.REVIEWS)
    .orderBy("createdAt", "desc")
    .limit(limitCount)
    .get();
  return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

export async function getFeedbackSnapshot() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.REVIEWS)
    .orderBy("createdAt", "desc")
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
    type: "review",
  }));
}

export async function resolveFeedback(reviewId: string) {
  const adminDb = getAdminDb();
  const ref = adminDb.collection(COLLECTIONS.REVIEWS).doc(reviewId);
  const current = await ref.get();
  const data = current.data() || {};

  await ref.set(
    {
      ...data,
      status: "resolved",
      resolvedAt: new Date(),
    },
    { merge: true },
  );

  return { id: reviewId, resolved: true };
}

export async function deleteFeedback(reviewId: string) {
  const adminDb = getAdminDb();
  await adminDb.collection(COLLECTIONS.REVIEWS).doc(reviewId).delete();
  return { id: reviewId, deleted: true };
}

export async function getReviewsCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.REVIEWS).count().get();
  return snapshot.data().count;
}
