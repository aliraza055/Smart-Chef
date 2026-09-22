import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { getUsersSnapshot } from "@/lib/services/reports";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const users = await getUsersSnapshot();
    return NextResponse.json({ users });
  } catch (error) {
    console.error("Users fetch error:", error);
    return NextResponse.json(
      { error: "Unable to load users" },
      { status: 500 }
    );
  }
}
