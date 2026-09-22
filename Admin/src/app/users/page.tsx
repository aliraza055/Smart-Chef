"use client";

import { useEffect, useMemo, useState } from "react";
import { Ban, ShieldAlert, ShieldCheck, Trash2, UserRound, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";

type UserRecord = {
  id: string;
  name?: string;
  gmail?: string;
  email?: string;
  imageUrl?: string;
  totalRecipes?: number;
  totalFavorites?: number;
  createdAt?: unknown;
  isRestricted?: boolean;
  accountStatus?: string;
};

const formatTimestamp = (value: unknown) => {
  if (!value) return "—";

  if (typeof value === "string") {
    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? value : date.toLocaleDateString();
  }

  if (typeof value === "number") {
    return new Date(value).toLocaleDateString();
  }

  if (value && typeof value === "object" && "toDate" in value && typeof (value as { toDate: () => Date }).toDate === "function") {
    return (value as { toDate: () => Date }).toDate().toLocaleDateString();
  }

  return String(value);
};

export default function UsersPage() {
  const [users, setUsers] = useState<UserRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [actioningId, setActioningId] = useState<string | null>(null);
  const [error, setError] = useState("");

  const refreshUsers = async () => {
    setLoading(true);
    setError("");

    try {
      const response = await fetch("/api/users", { credentials: "include" });
      if (!response.ok) {
        throw new Error("Unable to load users.");
      }

      const payload = await response.json();
      setUsers(Array.isArray(payload.users) ? payload.users : []);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : "Unable to load users.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void refreshUsers();
  }, []);

  const totalUsers = useMemo(() => users.length, [users]);
  const restrictedUsers = useMemo(
    () => users.filter((user) => user.isRestricted || user.accountStatus === "restricted").length,
    [users],
  );

  const handleToggleRestriction = async (user: UserRecord) => {
    const shouldRestrict = !(user.isRestricted || user.accountStatus === "restricted");
    const actionLabel = shouldRestrict ? "restrict" : "allow";

    const confirmed = window.confirm(
      `Are you sure you want to ${actionLabel} ${user.name || user.gmail || user.email || "this user"}?`,
    );

    if (!confirmed) return;

    setActioningId(user.id);
    setError("");

    try {
      const response = await fetch("/api/users", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          action: "toggleRestriction",
          userId: user.id,
          restricted: shouldRestrict,
        }),
      });

      if (!response.ok) {
        throw new Error("Unable to update the user's account status.");
      }

      setUsers((currentUsers) =>
        currentUsers.map((currentUser) =>
          currentUser.id === user.id
            ? {
                ...currentUser,
                isRestricted: shouldRestrict,
                accountStatus: shouldRestrict ? "restricted" : "active",
              }
            : currentUser,
        ),
      );
    } catch (updateError) {
      setError(updateError instanceof Error ? updateError.message : "Unable to update the user.");
    } finally {
      setActioningId(null);
    }
  };

  const handleDeleteUser = async (user: UserRecord) => {
    const label = user.name || user.gmail || user.email || "this user";
    const confirmed = window.confirm(`This will permanently delete ${label}. Continue?`);

    if (!confirmed) return;

    setActioningId(user.id);
    setError("");

    try {
      const response = await fetch("/api/users", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          action: "deleteUser",
          userId: user.id,
        }),
      });

      if (!response.ok) {
        throw new Error("Unable to delete the account.");
      }

      setUsers((currentUsers) => currentUsers.filter((currentUser) => currentUser.id !== user.id));
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : "Unable to delete the account.");
    } finally {
      setActioningId(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">User management</p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">Users</h1>
        </div>

        <div className="flex items-center gap-3">
          <Button variant="outline" onClick={() => void refreshUsers()}>
            <RefreshCw className="mr-2 h-4 w-4" />
            Refresh
          </Button>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Total users</span>
            <UserRound className="h-4 w-4 text-primary" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{totalUsers}</div>
        </div>

        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Active</span>
            <ShieldCheck className="h-4 w-4 text-emerald-500" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{totalUsers - restrictedUsers}</div>
        </div>

        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Restricted</span>
            <ShieldAlert className="h-4 w-4 text-red-500" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{restrictedUsers}</div>
        </div>
      </div>

      <div className="rounded-xl border border-border bg-surface overflow-hidden">
        {error ? (
          <div className="p-6 text-sm text-red-600">{error}</div>
        ) : null}

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-border text-left">
            <thead className="bg-background text-sm text-muted">
              <tr>
                <th className="px-4 py-3 font-medium">User</th>
                <th className="px-4 py-3 font-medium">Email</th>
                <th className="px-4 py-3 font-medium">Joined</th>
                <th className="px-4 py-3 font-medium">Status</th>
                <th className="px-4 py-3 font-medium">Recipes</th>
                <th className="px-4 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>

            <tbody className="divide-y divide-border text-sm text-foreground">
              {loading ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    Loading users...
                  </td>
                </tr>
              ) : users.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    No users found.
                  </td>
                </tr>
              ) : (
                users.map((user) => {
                  const isRestricted = Boolean(user.isRestricted || user.accountStatus === "restricted");

                  return (
                    <tr key={user.id} className="hover:bg-background/80">
                      <td className="px-4 py-3">
                        <div className="flex items-center gap-3">
                          <div className="flex h-10 w-10 items-center justify-center overflow-hidden rounded-full bg-primary/10 text-sm font-semibold text-primary">
                            {user.name ? user.name.trim().charAt(0).toUpperCase() : "U"}
                          </div>
                          <div>
                            <div className="font-medium">{user.name || "Unnamed user"}</div>
                            <div className="text-xs text-muted">{user.id.slice(0, 8)}</div>
                          </div>
                        </div>
                      </td>

                      <td className="px-4 py-3">{user.gmail || user.email || "—"}</td>
                      <td className="px-4 py-3">{formatTimestamp(user.createdAt)}</td>

                      <td className="px-4 py-3">
                        <span
                          className={`inline-flex rounded-full px-2.5 py-1 text-xs font-medium ${
                            isRestricted
                              ? "bg-red-100 text-red-700"
                              : "bg-emerald-100 text-emerald-700"
                          }`}
                        >
                          {isRestricted ? "Restricted" : "Active"}
                        </span>
                      </td>

                      <td className="px-4 py-3">{user.totalRecipes ?? 0}</td>

                      <td className="px-4 py-3">
                        <div className="flex items-center justify-end gap-2">
                          <Button
                            variant={isRestricted ? "secondary" : "outline"}
                            size="sm"
                            onClick={() => void handleToggleRestriction(user)}
                            disabled={actioningId === user.id}
                          >
                            {isRestricted ? <ShieldCheck className="mr-1 h-4 w-4" /> : <Ban className="mr-1 h-4 w-4" />}
                            {isRestricted ? "Allow" : "Restrict"}
                          </Button>

                          <Button
                            variant="danger"
                            size="sm"
                            onClick={() => void handleDeleteUser(user)}
                            disabled={actioningId === user.id}
                          >
                            <Trash2 className="mr-1 h-4 w-4" />
                            Delete
                          </Button>
                        </div>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
