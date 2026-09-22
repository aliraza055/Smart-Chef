import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { createCategory, deleteCategory, getCategoriesSnapshot, toggleCategoryStatus } from "@/lib/services/categories";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const categories = await getCategoriesSnapshot();
    return NextResponse.json({ categories });
  } catch (error) {
    console.error("Categories fetch error:", error);
    return NextResponse.json({ error: "Unable to load categories" }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const { action, name, categoryId, isActive } = await req.json();

    if (action === "create") {
      const category = await createCategory(name || "");
      return NextResponse.json({ success: true, category });
    }

    if (action === "toggle") {
      if (!categoryId) {
        return NextResponse.json({ error: "Missing categoryId" }, { status: 400 });
      }

      const result = await toggleCategoryStatus(categoryId, Boolean(isActive));
      return NextResponse.json({ success: true, category: result });
    }

    if (action === "delete") {
      if (!categoryId) {
        return NextResponse.json({ error: "Missing categoryId" }, { status: 400 });
      }

      const result = await deleteCategory(categoryId);
      return NextResponse.json({ success: true, category: result });
    }

    return NextResponse.json({ error: "Unsupported action" }, { status: 400 });
  } catch (error) {
    console.error("Category action error:", error);
    const message = error instanceof Error ? error.message : "Category action failed";
    return NextResponse.json({ error: message }, { status: 500 });
  }
}
