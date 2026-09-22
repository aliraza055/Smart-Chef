"use client";

import { useEffect, useState } from "react";
import { BellRing, Check, Lock, RefreshCw, ShieldCheck, SlidersHorizontal } from "lucide-react";
import { Button } from "@/components/ui/button";

type SettingsState = {
  siteName: string;
  supportEmail: string;
  maintenanceMode: boolean;
  autoModeration: boolean;
  emailNotifications: boolean;
  contentApproval: boolean;
};

const defaultSettings: SettingsState = {
  siteName: "SmartChef Admin",
  supportEmail: "admin@smartchef.app",
  maintenanceMode: false,
  autoModeration: true,
  emailNotifications: true,
  contentApproval: true,
};

export default function SettingsPage() {
  const [settings, setSettings] = useState<SettingsState>(defaultSettings);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    const fetchSettings = async () => {
      try {
        const response = await fetch("/api/settings", { credentials: "include" });
        if (!response.ok) throw new Error("Unable to load settings.");

        const payload = await response.json();
        setSettings({ ...defaultSettings, ...(payload.settings || {}) });
      } catch (loadError) {
        setError(loadError instanceof Error ? loadError.message : "Unable to load settings.");
      } finally {
        setLoading(false);
      }
    };

    void fetchSettings();
  }, []);

  const handleToggle = (key: keyof SettingsState, value: boolean) => {
    setSettings((current) => ({ ...current, [key]: value }));
  };

  const handleSave = async () => {
    setSaving(true);
    setError("");

    try {
      const response = await fetch("/api/settings", {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(settings),
      });

      if (!response.ok) {
        throw new Error("Unable to save settings.");
      }

      setSettings((current) => ({ ...current }));
    } catch (saveError) {
      setError(saveError instanceof Error ? saveError.message : "Unable to save settings.");
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted">Administration</p>
          <h1 className="mt-2 text-3xl font-bold tracking-tight text-foreground">Settings</h1>
        </div>

        <div className="flex items-center gap-3">
          <Button variant="outline" onClick={() => window.location.reload()}>
            <RefreshCw className="mr-2 h-4 w-4" />
            Reload
          </Button>
          <Button onClick={() => void handleSave()} disabled={saving}>
            {saving ? "Saving..." : "Save Changes"}
          </Button>
        </div>
      </div>

      <div className="grid gap-6 xl:grid-cols-[1.1fr_0.9fr]">
        <div className="rounded-xl border border-border bg-surface p-6">
          <div className="mb-5 flex items-center gap-3">
            <div className="rounded-lg bg-primary/10 p-2">
              <SlidersHorizontal className="h-5 w-5 text-primary" />
            </div>
            <h2 className="text-xl font-semibold text-foreground">General settings</h2>
          </div>

          <div className="space-y-5">
            <div>
              <label className="mb-2 block text-sm font-medium text-foreground">Site name</label>
              <input
                value={settings.siteName}
                onChange={(event) => setSettings((current) => ({ ...current, siteName: event.target.value }))}
                className="w-full rounded-lg border border-border bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
              />
            </div>

            <div>
              <label className="mb-2 block text-sm font-medium text-foreground">Support email</label>
              <input
                value={settings.supportEmail}
                onChange={(event) => setSettings((current) => ({ ...current, supportEmail: event.target.value }))}
                className="w-full rounded-lg border border-border bg-background px-3 py-2.5 text-sm text-foreground outline-none focus:border-primary"
              />
            </div>
          </div>
        </div>

        <div className="rounded-xl border border-border bg-surface p-6">
          <div className="mb-5 flex items-center gap-3">
            <div className="rounded-lg bg-emerald-500/10 p-2">
              <ShieldCheck className="h-5 w-5 text-emerald-500" />
            </div>
            <h2 className="text-xl font-semibold text-foreground">Security & moderation</h2>
          </div>

          <div className="space-y-4">
            <ToggleRow
              icon={<Lock className="h-4 w-4" />}
              title="Maintenance mode"
              subtitle="Temporarily pause public access"
              enabled={settings.maintenanceMode}
              onChange={(value) => handleToggle("maintenanceMode", value)}
            />
            <ToggleRow
              icon={<Check className="h-4 w-4" />}
              title="Auto moderation"
              subtitle="Review suspicious content automatically"
              enabled={settings.autoModeration}
              onChange={(value) => handleToggle("autoModeration", value)}
            />
            <ToggleRow
              icon={<BellRing className="h-4 w-4" />}
              title="Email notifications"
              subtitle="Send alerts for reports and updates"
              enabled={settings.emailNotifications}
              onChange={(value) => handleToggle("emailNotifications", value)}
            />
            <ToggleRow
              icon={<ShieldCheck className="h-4 w-4" />}
              title="Content approval"
              subtitle="Require review before publishing"
              enabled={settings.contentApproval}
              onChange={(value) => handleToggle("contentApproval", value)}
            />
          </div>
        </div>
      </div>

      {loading ? (
        <div className="rounded-xl border border-border bg-surface p-6 text-sm text-muted">Loading settings...</div>
      ) : null}
      {error ? <div className="rounded-xl border border-red-200 bg-red-50 p-4 text-sm text-red-700">{error}</div> : null}
    </div>
  );
}

function ToggleRow({
  icon,
  title,
  subtitle,
  enabled,
  onChange,
}: {
  icon: React.ReactNode;
  title: string;
  subtitle: string;
  enabled: boolean;
  onChange: (value: boolean) => void;
}) {
  return (
    <div className="flex items-center justify-between rounded-xl border border-border bg-background p-4">
      <div className="flex items-start gap-3">
        <div className="mt-0.5 rounded-md bg-primary/10 p-2 text-primary">{icon}</div>
        <div>
          <div className="font-medium text-foreground">{title}</div>
          <div className="text-sm text-muted">{subtitle}</div>
        </div>
      </div>

      <button
        type="button"
        onClick={() => onChange(!enabled)}
        className={`relative inline-flex h-6 w-11 items-center rounded-full transition-colors ${enabled ? "bg-primary" : "bg-border"}`}
        aria-label={title}
      >
        <span
          className={`inline-block h-4 w-4 transform rounded-full bg-white transition-transform ${enabled ? "translate-x-6" : "translate-x-1"}`}
        />
      </button>
    </div>
  );
}
