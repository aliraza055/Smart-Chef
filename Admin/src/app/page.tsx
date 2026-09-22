"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { Lock, Mail, ShieldCheck } from "lucide-react";
import { getAdminCredentials } from "@/lib/admin-auth";

export default function LoginPage() {
  const router = useRouter();
  const defaultCredentials = getAdminCredentials();
  const [email, setEmail] = useState(defaultCredentials.email);
  const [password, setPassword] = useState(defaultCredentials.password);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    async function verifySession() {
      const response = await fetch("/api/admin/session");
      const data = await response.json().catch(() => ({ authenticated: false }));

      if (data.authenticated) {
        router.replace("/dashboard");
      }
    }

    verifySession();
  }, [router]);

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      const response = await fetch("/api/admin/login", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json().catch(() => ({}));

      if (!response.ok) {
        throw new Error(data.error || "Invalid credentials");
      }

      router.replace(data.redirectTo || "/dashboard");
    } catch (loginError) {
      setError(loginError instanceof Error ? loginError.message : "Login failed");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-[radial-gradient(circle_at_top,#1f2937_0%,#0f172a_55%,#020817_100%)] px-4 py-8">
      <div className="w-full max-w-md rounded-2xl border border-white/10 bg-surface/95 p-6 shadow-2xl shadow-black/30 backdrop-blur">
        <div className="mb-6 flex items-center justify-center gap-3 text-primary">
          <div className="rounded-xl bg-primary/10 p-3">
            <ShieldCheck className="h-8 w-8" />
          </div>
          <div>
            <p className="text-xs uppercase tracking-[0.2em] text-muted">Secure access</p>
            <h1 className="text-2xl font-bold text-foreground">SmartChef Admin</h1>
          </div>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label htmlFor="email" className="mb-2 block text-sm font-medium text-foreground">
              Admin email
            </label>
            <div className="relative">
              <Mail className="pointer-events-none absolute left-3 top-3.5 h-4 w-4 text-muted" />
              <input
                id="email"
                type="email"
                value={email}
                onChange={(event) => setEmail(event.target.value)}
                className="w-full rounded-xl border border-border bg-background py-2.5 pl-10 pr-3 text-foreground outline-none transition focus:border-primary focus:ring-2 focus:ring-primary/20"
                placeholder="admin@smartchef.app"
                required
              />
            </div>
          </div>

          <div>
            <label htmlFor="password" className="mb-2 block text-sm font-medium text-foreground">
              Password
            </label>
            <div className="relative">
              <Lock className="pointer-events-none absolute left-3 top-3.5 h-4 w-4 text-muted" />
              <input
                id="password"
                type="password"
                value={password}
                onChange={(event) => setPassword(event.target.value)}
                className="w-full rounded-xl border border-border bg-background py-2.5 pl-10 pr-3 text-foreground outline-none transition focus:border-primary focus:ring-2 focus:ring-primary/20"
                placeholder="Enter admin password"
                required
              />
            </div>
          </div>

          {error ? (
            <div className="rounded-xl border border-red-500/30 bg-red-500/10 px-3 py-2 text-sm text-red-200">
              {error}
            </div>
          ) : null}

          <button
            type="submit"
            disabled={loading}
            className="w-full rounded-xl bg-primary px-4 py-3 font-medium text-white transition hover:bg-primary/90 disabled:cursor-not-allowed disabled:opacity-60"
          >
            {loading ? "Signing in..." : "Login to dashboard"}
          </button>
        </form>

        <div className="mt-5 rounded-xl border border-border bg-background/70 p-3 text-xs text-muted">
          Demo credentials: <span className="font-medium text-foreground">{defaultCredentials.email}</span> / <span className="font-medium text-foreground">{defaultCredentials.password}</span>
        </div>
      </div>
    </div>
  );
}
