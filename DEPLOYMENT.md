# David City: launch and real-booking checklist

## Current capabilities
- Responsive website served by the Node/Express backend.
- Booking enquiries are saved to `data/bookings.json` and survive local server restarts.
- Optional Paystack **test-mode** checkout is wired through the server. Payment status is verified server-side and amount/currency are checked.
- Sample listings are not live inventory. A successful test payment is not a hotel reservation and cannot charge real money.

## Run locally
1. Install Node.js 20+.
2. Copy `.env.example` to `.env`.
3. Put a Paystack **test secret key** in `PAYSTACK_SECRET_KEY` if you want to try the test checkout.
4. Run `npm install`, then `npm start`.
5. Open `http://localhost:3000`.

Do not share `.env` or place the Paystack secret key in `frontend/` code.

## Before accepting real customers or real money
1. Replace sample listings with properties you are authorized to sell, and verify addresses, ownership/authorization, room types, prices, taxes, cancellation/refund policies, and who fulfils each booking.
2. Connect a live availability source or implement a property-owner dashboard with inventory and date-level room counts. Recheck inventory atomically before confirmation to prevent double-booking. The current sample listing flow does not do this.
3. Use a production database (MySQL schema is in `database/schema.sql`) and configure backups, access controls, rate limiting, logging, privacy policy, terms, customer support and secure HTTPS hosting. Do not rely on local JSON files as production storage on ephemeral hosting.
4. Configure a production `PUBLIC_BASE_URL` such as `https://your-domain.example` and a Paystack **live** secret key as an environment secret at your hosting provider. Never put it in source control.
5. Only after real inventory and fulfilment are verified should you enable real payment handling. The current sample properties are intentionally blocked from live payment. Do not bypass this guard just to charge customers for fictional accommodation.
6. For production, use a proper booking/payment state machine and signed Paystack webhook handling with idempotency. Do not confirm a booking merely because a browser visits the callback URL. Verify payment status, amount, currency, and reference on the server.

## Booking provider option
Booking.com Demand API supports accommodation search and, for eligible partner integrations, supported booking flows. Access requires partner approval and credentials; it is not an anonymous/free public endpoint. See https://developers.booking.com/demand/docs/getting-started/overview and https://developers.booking.com/demand/docs/development-guide/authentication.

## Payment documentation
Paystack's official docs require transaction initialization on the server and verification of the successful status and amount before delivering value: https://paystack.com/docs/payments/accept-payments/ and https://paystack.com/docs/payments/verify-payments/.

## Health check
After starting the server, open `http://localhost:3000/api/health`. It reports database configuration and whether Paystack credentials are configured. Do not expose secrets in health output.
