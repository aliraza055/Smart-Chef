import { NextResponse } from "next/server";
import { ADMIN_COOKIE_NAME, getAdminCredentials, getAdminSessionSecret, isValidAdminCredentials } from "@/lib/admin-auth";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const email = typeof body?.email === "string" ? body.email : "";
    const password = typeof body?.password === "string" ? body.password : "";

    if (!isValidAdminCredentials(email, password)) {
      return NextResponse.json(
        { error: "Invalid admin credentials." },
        { status: 401 },
      );
    }

    const response = NextResponse.json({
      ok: true,
      redirectTo: "/dashboard",
      adminEmail: getAdminCredentials().email,
    });

    response.cookies.set({
      name: ADMIN_COOKIE_NAME,
      value: getAdminSessionSecret(),
      httpOnly: true,
      sameSite: "lax",
      secure: process.env.NODE_ENV === "production",
      path: "/",
      maxAge: 60 * 60 * 8,
    });

    return response;
  } catch {
    return NextResponse.json({ error: "Invalid login request." }, { status: 400 });
  }
}
