export const ADMIN_COOKIE_NAME = "admin_token";
export const DEFAULT_ADMIN_EMAIL = "admin@smartchef.app";
export const DEFAULT_ADMIN_PASSWORD = "admin123";

export function getAdminSessionSecret(): string {
  return (process.env.NEXT_ADMIN_SECRET || "").trim() || "smartchef-admin-session";
}

export function getAdminCredentials() {
  return {
    email: (process.env.ADMIN_EMAIL || DEFAULT_ADMIN_EMAIL).trim(),
    password: (process.env.ADMIN_PASSWORD || DEFAULT_ADMIN_PASSWORD).trim(),
  };
}

export function isValidAdminCredentials(email?: string, password?: string): boolean {
  const { email: expectedEmail, password: expectedPassword } = getAdminCredentials();

  return (
    (email || "").trim().toLowerCase() === expectedEmail.toLowerCase() &&
    (password || "") === expectedPassword
  );
}
