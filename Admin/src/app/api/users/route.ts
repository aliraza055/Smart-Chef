import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { deleteUserAccount, getAllUsersSnapshot, updateUserRestriction } from "@/lib/services/users";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const users = await getAllUsersSnapshot();
    return NextResponse.json({ users });
  } catch (error) {
    console.error("Users fetch error:", error);
    return NextResponse.json(
      { error: "Unable to load users" },
      { status: 500 }
    );
  }
}

export async function POST(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const { action, userId, restricted } = await req.json();

    if (!userId || !action) {
      return NextResponse.json({ error: "Missing userId or action" }, { status: 400 });
    }

    if (action === "toggleRestriction") {
      const result = await updateUserRestriction(userId, Boolean(restricted));
      return NextResponse.json({ success: true, user: result });
    }

    if (action === "deleteUser") {
      const result = await deleteUserAccount(userId);
      return NextResponse.json({ success: true, user: result });
    }

    return NextResponse.json({ error: "Unsupported action" }, { status: 400 });
  } catch (error) {
    console.error("User action error:", error);
    return NextResponse.json(
      { error: "User action failed" },
      { status: 500 }
    );
  }
}
