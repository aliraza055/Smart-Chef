The SmartChef Admin Dashboard UI is already created in the `Admin` Next.js application.

Now I want to replace ALL dummy/mock data with the **real Firebase data already being used by the SmartChef Flutter application inside `App/`**.

## Main requirement

Do NOT create new dummy data.

Do NOT create a separate database.

Do NOT create duplicate Firebase collections.

The Admin Panel must use the **same Firebase project and the same Firestore data** that the existing SmartChef Flutter application is already using.

The Admin Dashboard should reflect the actual current state of the SmartChef application.

---

# 1. First inspect the Flutter App

Before writing the Firebase integration, inspect:

`../App/`

Carefully find and understand:

* Firebase configuration
* Firebase project
* Firebase Authentication setup
* Firestore configuration
* Existing Firestore collections
* Collection/document structure
* User fields
* Recipe fields
* Feedback fields
* Any report/social-related collections
* Existing Firebase Storage usage
* Existing status fields
* Existing timestamps
* Existing relationships/references

Look at the actual Flutter code/models/services/repositories to determine how data is currently stored.

Do NOT guess the collection names or field names.

For example, if the Flutter app uses:

`users`

then use `users`.

If it uses:

`recipes`

then use `recipes`.

If it uses a different structure, follow the existing structure exactly.

---

# 2. Reuse the existing Firebase project

Configure the Next.js Admin application to connect to the SAME Firebase project used by the Flutter App.

Do not create another Firebase project.

Do not create another Firestore database.

Use the existing Firebase configuration.

Use environment variables for Firebase configuration rather than hardcoding sensitive configuration in source code.

Create an appropriate `.env.local` structure.

Do NOT expose Firebase Admin SDK credentials or service-account private keys to the browser.

---

# 3. Replace dashboard mock data

Currently the dashboard contains dummy values such as:

* Total Users
* Total Recipes
* Feedback
* Active Users
* Reported Content
* New Users
* Recent Activity
* Recent Recipes
* Charts

Replace all of these with real Firestore data.

For example:

### Total Users

Count actual user documents from the existing user collection.

### Total Recipes

Count actual recipe documents.

### Feedback

Count actual feedback documents.

### Reported Content

Use the existing report/reporting collection or existing reporting structure from the Flutter App.

Do not invent a new collection if the App already has one.

### Recent Recipes

Fetch actual recently created recipes from Firestore using the existing timestamp field.

### Recent Activity

If the existing application already stores activity data, use it.

If there is no activity collection in the existing App, DO NOT create fake activity.

Instead, either:

1. derive meaningful activity from existing Firestore documents/timestamps, or
2. leave the section empty with a proper "No recent activity" state.

Never display fake activity as real activity.

---

# 4. Real-time updates

The dashboard should update when Firestore data changes.

Use Firestore real-time listeners where appropriate.

For example:

When a new user registers in the Flutter App:

Flutter App
↓
Firebase Authentication / Firestore
↓
New user document
↓
Next.js Admin Dashboard
↓
Dashboard updates automatically

Similarly:

New Recipe
↓
Firestore
↓
Recipe count updates

New Feedback
↓
Firestore
↓
Feedback count updates

Recipe/User Report
↓
Firestore
↓
Reported content count updates

Avoid unnecessary polling if Firestore real-time listeners can be used.

---

# 5. Dashboard statistics

Make the following cards dynamic:

* Total Users
* Active Users
* Total Recipes
* Reported Content
* Feedback
* New Users

Do not hardcode values.

If a statistic cannot be calculated from the existing Firebase data, do not invent a number.

Instead, clearly identify what data is missing.

---

# 6. User growth chart

The current User Growth chart uses mock data.

Replace it with real user registration data.

Use the existing user creation timestamp field from Firestore.

Calculate registrations over a meaningful period, for example:

* Last 7 days
* Last 30 days
* Last 6 months

Choose an appropriate default based on the amount of existing data.

The chart must represent actual SmartChef user registration data.

Do not generate random numbers.

---

# 7. Recipe statistics

Replace mock recipe statistics with actual Firestore data.

For example:

* Total Recipes
* Published/Active Recipes
* Hidden Recipes
* Reported Recipes

Only show statuses that actually exist in the current data model.

If the Flutter App does not currently have a `status` field, do not pretend that it does.

First inspect the model and adapt the Admin Panel to the existing structure.

---

# 8. Recent recipes

Connect the Recent Recipes table to the real recipe collection.

Display actual:

* Recipe image
* Recipe name
* Author
* Category
* Created date
* Status if available

Use the existing Firestore fields.

If recipe images are stored in Firebase Storage, correctly load the existing image URLs/references.

Handle missing images gracefully.

---

# 9. Loading states

Because data is now coming from Firebase, implement proper loading states.

For example:

`Loading users...`

or preferably skeleton loaders for dashboard cards.

Do not show fake numbers while Firebase is loading.

---

# 10. Empty states

Handle cases where there is no data.

For example:

`No recipes found`

`No recent activity`

`No feedback available`

Do not fill empty sections with dummy data.

---

# 11. Error handling

Implement proper Firebase error handling.

If Firebase fails:

Show a user-friendly message such as:

"Unable to load dashboard data. Please try again."

Do not silently display dummy/mock data as a fallback.

Log useful technical errors for development without exposing sensitive Firebase information to users.

---

# 12. Performance

Do not fetch every document unnecessarily just to calculate dashboard statistics.

Use efficient Firestore queries where possible.

Avoid downloading thousands of recipe/user documents to the browser if only a count is required.

Use appropriate Firestore query methods, indexes and aggregation/count functionality where suitable.

For charts, fetch only the data required for the selected time range.

---

# 13. Security

This is an ADMIN PANEL.

Do NOT assume that hiding the Admin UI from normal users provides security.

Admin authorization must be enforced properly.

Normal SmartChef users must NOT be able to access administrative functionality simply by discovering the Admin URL.

Do not expose Firebase Admin SDK/service account credentials in client-side code.

Keep sensitive server-side operations on the server.

Before implementing destructive operations later, design the authorization structure properly.

---

# 14. Important architecture requirement

Keep Firebase access separate from UI components.

For example:

Admin/
├── app/
├── components/
├── lib/
│   ├── firebase/
│   │   ├── config
│   │   ├── client
│   │   └── server
│   ├── services/
│   │   ├── users
│   │   ├── recipes
│   │   ├── feedback
│   │   └── reports
│   └── types/
│
└── ...

Do not put large Firestore queries directly inside dashboard UI components.

Create reusable service functions.

For example conceptually:

`getUsersCount()`

`getRecipesCount()`

`getFeedbackCount()`

`getRecentRecipes()`

`getUserGrowthData()`

Adapt the actual implementation to the existing project architecture.

---

# 15. Do not modify the Flutter App unnecessarily

The Flutter application is already working.

Do NOT restructure or rewrite the Flutter application just to make the Admin Panel easier.

The Admin Panel should adapt to the existing Firebase data model.

Only modify the Flutter App if absolutely necessary and explain why before doing so.

---

# 16. Very important: inspect first, code second

Before implementing Firebase integration, show me:

1. Firebase project/configuration currently used by the Flutter App
2. Firestore collections found
3. Important fields in each collection
4. Which collections will power each dashboard statistic
5. Which existing fields will be used for charts
6. Which sections cannot currently be populated because the App does not store the required data

Then implement the integration.

After implementation, remove all dummy/mock dashboard data and verify that the dashboard is displaying the actual SmartChef Firebase data.

The final result should be:

Flutter SmartChef App
↓
Existing Firebase
↓
Same Firebase
↓
Next.js SmartChef Admin Dashboard

There must be ONE source of truth: the existing SmartChef Firebase project/data.
