"use client";

import { useEffect, useMemo, useState } from "react";
import { AlertTriangle, CheckCheck, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";

type ReportRecord = {
  id: string;
  itemId: string;
  type: "recipe" | "review";
  title: string;
  author: string;
  reason: string;
  status?: string;
  createdAt?: unknown;
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

export default function ReportsPage() {
  const [reports, setReports] = useState<ReportRecord[]>([]);
  const [count, setCount] = useState(0);
  const [loading, setLoading] = useState(true);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [error, setError] = useState("");

  const refreshReports = async () => {
    setLoading(true);
    setError("");

    try {
      const response = await fetch("/api/reports", { credentials: "include" });
      if (!response.ok) {
        throw new Error("Unable to load reports.");
      }

      const payload = await response.json();
      setReports(Array.isArray(payload.reports) ? payload.reports : []);
      setCount(Number(payload.count || 0));
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : "Unable to load reports.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    void refreshReports();
  }, []);

  const totalOpenReports = useMemo(() => reports.length, [reports]);

  const handleResolve = async (report: ReportRecord) => {
    const confirmed = window.confirm(`Resolve this ${report.type} report?`);
    if (!confirmed) return;

    setBusyId(report.id);
    setError("");

    try {
      const response = await fetch("/api/reports", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ action: "resolve", itemId: report.itemId, type: report.type }),
      });

      if (!response.ok) {
        throw new Error("Unable to resolve the report.");
      }

      setReports((current) => current.filter((item) => item.id !== report.id));
      setCount((current) => Math.max(0, current - 1));
    } catch (resolveError) {
      setError(resolveError instanceof Error ? resolveError.message : "Unable to resolve the report.");
    } finally {
      setBusyId(null);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">Moderation queue</p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">Reports</h1>
        </div>

        <div className="flex items-center gap-3">
          <Button variant="outline" onClick={() => void refreshReports()}>
            <RefreshCw className="mr-2 h-4 w-4" />
            Refresh
          </Button>
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Pending reports</span>
            <AlertTriangle className="h-4 w-4 text-amber-500" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{count}</div>
        </div>

        <div className="rounded-xl border border-border bg-surface p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm text-muted">Visible queue</span>
            <CheckCheck className="h-4 w-4 text-emerald-500" />
          </div>
          <div className="mt-3 text-2xl font-bold text-foreground">{totalOpenReports}</div>
        </div>
      </div>

      <div className="rounded-xl border border-border bg-surface overflow-hidden">
        {error ? <div className="p-6 text-sm text-red-600">{error}</div> : null}

        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-border text-left">
            <thead className="bg-background text-sm text-muted">
              <tr>
                <th className="px-4 py-3 font-medium">Item</th>
                <th className="px-4 py-3 font-medium">Type</th>
                <th className="px-4 py-3 font-medium">Reported by</th>
                <th className="px-4 py-3 font-medium">Reason</th>
                <th className="px-4 py-3 font-medium">Date</th>
                <th className="px-4 py-3 font-medium text-right">Action</th>
              </tr>
            </thead>

            <tbody className="divide-y divide-border text-sm text-foreground">
              {loading ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    Loading reports...
                  </td>
                </tr>
              ) : reports.length === 0 ? (
                <tr>
                  <td colSpan={6} className="px-4 py-10 text-center text-muted">
                    No reports found.
                  </td>
                </tr>
              ) : (
                reports.map((report) => (
                  <tr key={report.id} className="hover:bg-background/80">
                    <td className="px-4 py-3">
                      <div className="font-medium">{report.title}</div>
                      <div className="text-xs text-muted">{report.itemId.slice(0, 8)}</div>
                    </td>
                    <td className="px-4 py-3 capitalize">{report.type}</td>
                    <td className="px-4 py-3">{report.author || "Unknown"}</td>
                    <td className="px-4 py-3 max-w-xs">{report.reason || "Flagged by a user"}</td>
                    <td className="px-4 py-3">{formatTimestamp(report.createdAt)}</td>
                    <td className="px-4 py-3 text-right">
                      <Button
                        variant="secondary"
                        size="sm"
                        onClick={() => void handleResolve(report)}
                        disabled={busyId === report.id}
                      >
                        <CheckCheck className="mr-1 h-4 w-4" />
                        Resolve
                      </Button>
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
