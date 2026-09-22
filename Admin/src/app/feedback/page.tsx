"use client";

import { useEffect, useState } from "react";
import { CheckCheck, MessageSquareText, RefreshCw, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";

type FeedbackRecord = {
  id: string;
  userName?: string;
  userId?: string;
  comment?: string;
  rating?: number;
  recipeId?: string;
  createdAt?: unknown;
  status?: string;
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

export default function FeedbackPage() {
  const [feedback, setFeedback] = useState<FeedbackRecord[]>([]);
  const [loading, setLoading] = useState(true);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [error, setError] = useState("");

  const refreshFeedback = async () => {
    setLoading(true);
    setError("");

    try {
      const response = await fetch("/api/feedback", { credentials: "include" });
      if (!response.ok) {
        throw new Error("Unable to load feedback.");
      }

      const payload = await response.json();
      setFeedback(Array.isArray(payload.feedback) ? payload.feedback : []);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : "Unable to load feedback.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void refreshFeedback();
  }, []);

  const handleResolve = async (record: FeedbackRecord) => {
    const confirmed = window.confirm("Mark this feedback as resolved?");
    if (!confirmed) return;

    setBusyId(record.id);
    setError("");

    try {
      const response = await fetch("/api/feedback", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "resolve", feedbackId: record.id }),
      });

      if (!response.ok) {
        throw new Error("Unable to resolve the feedback.");
      }

      setFeedback((current) => current.filter((item) => item.id !== record.id));
    } catch (resolveError) {
      setError(resolveError instanceof Error ? resolveError.message : "Unable to resolve feedback.");
    } finally {
      setBusyId(null);
    }
  };

  const handleDelete = async (record: FeedbackRecord) => {
    const confirmed = window.confirm("Delete this feedback item?");
    if (!confirmed) return;

    setBusyId(record.id);
    setError("");

    try {
      const response = await fetch("/api/feedback", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "delete", feedbackId: record.id }),
      });

      if (!response.ok) {
        throw new Error("Unable to delete the feedback.");
      }

      setFeedback((current) => current.filter((item) => item.id !== record.id));
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : "Unable to delete feedback.");
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">User feedback</p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">Feedback</h1>
        </div>

        <div className="flex items-center gap-3">
          <Button variant="outline" onClick={() => void refreshFeedback()}>
            <RefreshCw className="mr-2 h-4 w-4" />
            Refresh
          </Button>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Feedback items</span>
            <MessageSquareText className="h-4 w-4 text-primary" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{feedback.length}</div>
        </div>

        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Status</span>
            <CheckCheck className="h-4 w-4 text-emerald-500" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">Open</div>
        </div>
      </div>

      <div className="rounded-xl border border-border bg-surface overflow-hidden">
        {error ? <div className="p-6 text-sm text-red-600">{error}</div> : null}

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-border text-left">
            <thead className="bg-background text-sm text-muted">
              <tr>
                <th className="px-4 py-3 font-medium">User</th>
                <th className="px-4 py-3 font-medium">Rating</th>
                <th className="px-4 py-3 font-medium">Comment</th>
                <th className="px-4 py-3 font-medium">Recipe</th>
                <th className="px-4 py-3 font-medium">Date</th>
                <th className="px-4 py-3 font-medium text-right">Actions</th>
              </tr>
            </thead>

            <tbody className="divide-y divide-border text-sm text-foreground">
              {loading ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    Loading feedback...
                  </td>
                </tr>
              ) : feedback.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    No feedback found.
                  </td>
                </tr>
              ) : (
                feedback.map((item) => (
                  <tr key={item.id} className="hover:bg-background/80 align-top">
                    <td className="px-4 py-3">
                      <div className="font-medium">{item.userName || "Anonymous"}</div>
                      <div className="text-xs text-muted">{item.userId ? item.userId.slice(0, 8) : "—"}</div>
                    </td>
                    <td className="px-4 py-3">{item.rating ?? "—"}</td>
                    <td className="px-4 py-3 max-w-md">{item.comment || "No comment provided"}</td>
                    <td className="px-4 py-3">{item.recipeId || "General"}</td>
                    <td className="px-4 py-3">{formatTimestamp(item.createdAt)}</td>
                    <td className="px-4 py-3 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <Button
                          variant="secondary"
                          size="sm"
                          onClick={() => void handleResolve(item)}
                          disabled={busyId === item.id}
                        >
                          <CheckCheck className="mr-1 h-4 w-4" />
                          Resolve
                        </Button>

                        <Button
                          variant="danger"
                          size="sm"
                          onClick={() => void handleDelete(item)}
                          disabled={busyId === item.id}
                        >
                          <Trash2 className="mr-1 h-4 w-4" />
                          Delete
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}
