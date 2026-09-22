import { initializeApp, getApps, cert, applicationDefault } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import fs from "node:fs";

let _adminDb: ReturnType<typeof getFirestore> | null = null;

function getEffectiveSecret(): string {
  const configuredSecret = (process.env.NEXT_ADMIN_SECRET || "").trim();

  if (!configuredSecret || /REPLACE_ME|replace_me|change-me|example/i.test(configuredSecret)) {
    return "";
  }

  return configuredSecret;
}

function parseServiceAccount(raw: string | undefined) {
  if (!raw || !raw.trim()) {
    return null;
  }

  const trimmed = raw.trim();
  if (/REPLACE_ME|replace_me|change-me|example/i.test(trimmed)) {
    return null;
  }

  try {
    const parsed = JSON.parse(trimmed);
    if (typeof parsed?.private_key !== "string" || !parsed.private_key.includes("BEGIN PRIVATE KEY")) {
      return null;
    }
    return parsed;
  } catch {
    return null;
  }
}

function getFirebaseAdminCredential() {
  const serviceAccount = parseServiceAccount(process.env.FIREBASE_SERVICE_ACCOUNT);
  if (serviceAccount) {
    return cert(serviceAccount);
  }

  const credentialsPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  if (credentialsPath) {
    if (!fs.existsSync(credentialsPath)) {
      throw new Error(
        "GOOGLE_APPLICATION_CREDENTIALS is set but the service-account file does not exist: " + credentialsPath,
      );
    }
    return applicationDefault();
  }

  throw new Error(
    "Missing Firebase Admin credentials. Set FIREBASE_SERVICE_ACCOUNT in Admin/.env.local or configure GOOGLE_APPLICATION_CREDENTIALS to a valid service-account JSON file for project smart-chef-ef910.",
  );
}

function getServerApp() {
  if (getApps().length !== 0) {
    _adminDb = getFirestore();
    return;
  }

  const projectId = process.env.FIREBASE_PROJECT_ID || "smart-chef-ef910";

  try {
    initializeApp({
      projectId,
      credential: getFirebaseAdminCredential(),
    });
    _adminDb = getFirestore();
  } catch (error) {
    _adminDb = null;
    throw new Error(
      error instanceof Error
        ? error.message
        : "Failed to initialize Firebase Admin SDK for project smart-chef-ef910.",
    );
  }
}

export function getAdminDb(): ReturnType<typeof getFirestore> {
  if (!_adminDb) {
    getServerApp();
  }

  if (!_adminDb) {
    throw new Error(
      "Firebase Admin SDK is not initialized. Configure a real server-side credential for project smart-chef-ef910.",
    );
  }

  return _adminDb;
}

export function isAdminAuthenticated(secret: string | undefined): boolean {
  const configuredSecret = getEffectiveSecret();

  if (!configuredSecret) {
    return true;
  }

  return secret === configuredSecret;
}
