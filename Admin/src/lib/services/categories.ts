import { getAdminDb } from "../firebase/server";

const CATEGORIES_COLLECTION = "Categories";

export async function getCategoriesSnapshot() {
  const adminDb = getAdminDb();
  const snapshot = await adminDb
    .collection(CATEGORIES_COLLECTION)
    .orderBy("createdAt", "desc")
    .get();

  return snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
    name: doc.data().name || doc.data().title || doc.id,
    isActive: doc.data().isActive ?? true,
  }));
}

export async function createCategory(name: string) {
  const adminDb = getAdminDb();
  const trimmed = name.trim();

  if (!trimmed) {
    throw new Error("Category name is required.");
  }

  const slug = trimmed.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-+|-+$/g, "") || "category";
  const ref = adminDb.collection(CATEGORIES_COLLECTION).doc(slug);
  const current = await ref.get();

  if (current.exists) {
    throw new Error("This category already exists.");
  }

  const payload = {
    id: slug,
    name: trimmed,
    slug,
    isActive: true,
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  await ref.set(payload);
  return { id: slug, ...payload };
}

export async function toggleCategoryStatus(categoryId: string, isActive: boolean) {
  const adminDb = getAdminDb();
  const ref = adminDb.collection(CATEGORIES_COLLECTION).doc(categoryId);
  const current = await ref.get();

  if (!current.exists) {
    throw new Error("Category not found.");
  }

  await ref.set(
    {
      ...current.data(),
      isActive,
      updatedAt: new Date(),
    },
    { merge: true },
  );

  return { id: categoryId, isActive };
}

export async function deleteCategory(categoryId: string) {
  const adminDb = getAdminDb();
  await adminDb.collection(CATEGORIES_COLLECTION).doc(categoryId).delete();
  return { id: categoryId, deleted: true };
}
