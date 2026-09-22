import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { getReportsSnapshot, getReportedContentCount, markReportResolved } from "@/lib/services/reports";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const [reports, count] = await Promise.all([
      getReportsSnapshot(),
      getReportedContentCount(),
    ]);

    return NextResponse.json({ reports, count });
  } catch (error) {
    console.error("Reports fetch error:", error);
    return NextResponse.json({ error: "Unable to load reports" }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const { action, itemId, type } = await req.json();

    if (!itemId || !type || action !== "resolve") {
      return NextResponse.json({ error: "Invalid report action" }, { status: 400 });
    }

    const result = await markReportResolved(itemId, type);
    return NextResponse.json({ success: true, report: result });
  } catch (error) {
    console.error("Report action error:", error);
    return NextResponse.json({ error: "Unable to resolve report" }, { status: 500 });
  }
}
