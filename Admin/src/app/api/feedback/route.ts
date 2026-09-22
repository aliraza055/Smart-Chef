import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";
import { deleteFeedback, getFeedbackSnapshot, resolveFeedback } from "@/lib/services/feedback";

function verifyAdmin(req: NextRequest): boolean {
  const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
  return isAdminAuthenticated(token);
}

export async function GET(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const feedback = await getFeedbackSnapshot();
    return NextResponse.json({ feedback });
  } catch (error) {
    console.error("Feedback fetch error:", error);
    return NextResponse.json({ error: "Unable to load feedback" }, { status: 500 });
  }
}

export async function POST(req: NextRequest) {
  if (!verifyAdmin(req)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const { action, feedbackId } = await req.json();

    if (!feedbackId || !action) {
      return NextResponse.json({ error: "Missing feedbackId or action" }, { status: 400 });
    }

    if (action === "resolve") {
      const result = await resolveFeedback(feedbackId);
      return NextResponse.json({ success: true, feedback: result });
    }

    if (action === "delete") {
      const result = await deleteFeedback(feedbackId);
      return NextResponse.json({ success: true, feedback: result });
    }

    return NextResponse.json({ error: "Unsupported action" }, { status: 400 });
  } catch (error) {
    console.error("Feedback action error:", error);
    return NextResponse.json({ error: "Feedback action failed" }, { status: 500 });
  }
}
