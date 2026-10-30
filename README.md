# David City — Hotel & Apartment Comparison Website

David City is a responsive hotel-comparison website with a vanilla HTML/CSS/JavaScript frontend and an Express REST API. It includes illustrative accommodation cards, search, sorting, filters, a property details modal, and a demo booking request flow.

**Important:** This is a learning/demo project. Prices and listings are illustrative, ratings are not verified, and no live hotel provider or payment service is connected. A booking reference confirms that David City saved an enquiry; it is not a confirmed reservation. To confirm real hotel availability and reservations, integrate a hotel/property inventory provider or connect each property owner to the enquiry workflow.

## 1. Requirements
- Node.js 18 or newer
- MySQL 8.x (optional; demo mode works without MySQL)
- VS Code

## 2. Install dependencies
Open the project folder in VS Code. Open **Terminal → New Terminal**, then run:

```bash
npm install
```

You can run the website without a database first. The example environment file has `DB_ENABLED=false`, so the app starts in demo mode without MySQL. Booking enquiries and contact messages are saved persistently to `data/bookings.json` and `data/contacts.json` when MySQL is not enabled, and survive server restarts. Keep those files private because they contain personal data. For a production deployment, use a protected database instead. Do not upload `.env` to GitHub.

## 3. Set up MySQL
Start MySQL, then run these SQL files in order using MySQL Workbench or the MySQL command line:

```sql
SOURCE database/schema.sql;
SOURCE database/seed.sql;
```

If using the command line, first navigate to the project directory and run:

```bash
mysql -u root -p < database/schema.sql
mysql -u root -p david_city < database/seed.sql
```

The SQL seed adds sample listings and sample room inventory. Inventory is only sample data and must not be used for real reservations.

After importing both SQL files, set `DB_ENABLED=true` in `.env` and verify the database credentials.

## 4. Run the site
In the VS Code terminal:

```bash
npm start
```

The website and API start together at `http://localhost:3000`. Open that URL in your browser; the backend serves the frontend, so you do not need Live Server. If you do use Live Server on port 5500, the frontend is configured to call the API at port 3000.

If MySQL is not enabled, the API returns sample listings and saves booking enquiries/contact messages to JSON files on the server. This is useful for local testing, but JSON-file storage is not suitable for a public multi-user production deployment.

## 5. Test API endpoints
Open these URLs in your browser:
- `http://localhost:3000/api/health`
- `http://localhost:3000/api/properties`
- `http://localhost:3000/api/properties/1`
- `http://localhost:3000/api/search?destination=Lagos&maxPrice=400000&minStars=3`
- `http://localhost:3000/api/properties/1/availability?checkin=2026-10-20&checkout=2026-10-22`

Example booking request using curl:

```bash
curl -X POST http://localhost:3000/api/bookings \
  -H "Content-Type: application/json" \
  -d "{\"propertyId\":1,\"guestName\":\"Demo Guest\",\"email\":\"guest@example.com\",\"phone\":\"+2348000000000\",\"checkIn\":\"2026-11-10\",\"checkOut\":\"2026-11-12\",\"guests\":2}"
```

Example contact request:

```bash
curl -X POST http://localhost:3000/api/contact \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"Demo Guest\",\"email\":\"guest@example.com\",\"message\":\"I have a question about this demo.\"}"
```

## 6. Beginner explanation
- `frontend/index.html` defines the page structure and form controls.
- `frontend/styles.css` handles colors, layout, responsive breakpoints, cards, and modal styling.
- `frontend/app.js` handles search, filters, sorting, dates, property details, and booking requests.
- `backend/server.js` exposes JSON endpoints, validates requests, and uses parameterized SQL queries.
- `database/schema.sql` creates the database tables and relationships.
- `database/seed.sql` adds the sample properties, photos, room options, and inventory.
- `.env` stores local database settings and is excluded from Git.

## 7. Troubleshooting
- **`npm` is not recognized:** install a current Node.js LTS release, close and reopen VS Code, then check `node -v` and `npm -v`.
- **Cannot connect to MySQL:** confirm MySQL is running and `.env` values match your local setup.
- **Port 3000 is already in use:** change `PORT=3001` in `.env`, then open `http://localhost:3001`.
- **Browser says Failed to fetch:** start the backend with `npm start`. Check `http://localhost:3000/api/health`.
- **Images do not appear:** the sample images use remote Unsplash URLs and need an internet connection. Replace them with images you own or have permission to use.
- **Database error on booking:** ensure the schema and seed files were both imported, including room inventory for the chosen dates.
- **Frontend only shows demo mode:** this is expected if the API is offline or the API request fails.

## 8. Deployment notes
The frontend can be hosted on a static host such as GitHub Pages, Netlify, or Vercel. Deploy the backend separately to a Node-capable host and attach a managed MySQL database. Set environment variables in the backend host dashboard. Update `API_BASE` in `frontend/app.js` to your deployed API URL and configure CORS to allow only your deployed frontend domain.

Before production, add authentication for administrators, rate limiting, stronger validation, structured logging, HTTPS, email verification, privacy terms, abuse protection, and a proper inventory model. Use provider contracts/API integrations for actual hotel rates and reservations. The current booking route is a demo request flow, not a production-grade booking engine.
