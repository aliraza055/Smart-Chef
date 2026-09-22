import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  return NextResponse.json({
    settings: {
      siteName: "SmartChef Admin",
      supportEmail: "admin@smartchef.app",
      maintenanceMode: false,
      autoModeration: true,
      emailNotifications: true,
      contentApproval: true,
    },
  });
}

export async function POST(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const payload = await req.json();
    return NextResponse.json({ success: true, settings: payload });
  } catch {
    return NextResponse.json({ error: "Invalid settings payload" }, { status: 400 });
  }
}
