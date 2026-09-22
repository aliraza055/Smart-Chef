import { getAdminDb } from "../firebase/server";
import { COLLECTIONS } from "../firebase/constants";

export async function getRecipeStats() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.RECIPES).get();
  let total = 0;
  let published = 0;
  let hidden = 0;
  let reported = 0;

  snapshot.docs.forEach((doc) => {
    total++;
    const data = doc.data();
    const status = data.status;
    if (
      status === "active" ||
      status === "published" ||
      status === "Active" ||
      status === "Published"
    ) {
      published++;
    } else if (status === "hidden" || status === "Hidden") {
      hidden++;
    } else if (status === "reported" || status === "Reported") {
      reported++;
    }
  });

  return { total, published, hidden, reported };
}

export async function getRecipeCount(): Promise<number> {
  const adminDb = getAdminDb();
  const snapshot = await adminDb.collection(COLLECTIONS.RECIPES).count().get();
  return snapshot.data().count;
}

export async function getAllRecipesSnapshot() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(COLLECTIONS.RECIPES)
    .orderBy("createdAt", "desc")
    .get();

  return snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

export async function updateRecipeStatus(recipeId: string, status: string) {
  const adminDb = getAdminDb();
  const recipeRef = adminDb.collection(COLLECTIONS.RECIPES).doc(recipeId);
  const currentDoc = await recipeRef.get();
  const currentData = currentDoc.data() || {};

  const nextStatus = status === "hidden" ? "hidden" : "active";

  await recipeRef.set(
    {
      ...currentData,
      status: nextStatus,
      updatedAt: new Date(),
    },
    { merge: true },
  );

  return { id: recipeId, status: nextStatus };
}

export async function deleteRecipe(recipeId: string) {
  const adminDb = getAdminDb();
  await adminDb.collection(COLLECTIONS.RECIPES).doc(recipeId).delete();
  return { id: recipeId, deleted: true };
}
