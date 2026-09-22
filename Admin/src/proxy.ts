import { NextRequest, NextResponse } from "next/server";
import { isAdminAuthenticated } from "@/lib/firebase/server";

export async function proxy(req: NextRequest) {
  const { pathname } = req.nextUrl;

  const apiPaths = ["/api/"];
  const isApi = apiPaths.some((p) => pathname.startsWith(p));

  if (isApi) {
    const token = req.cookies.get("admin_token")?.value || req.headers.get("authorization")?.replace("Bearer ", "");
    if (!isAdminAuthenticated(token)) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico|.*\\..*).*)"],
};
