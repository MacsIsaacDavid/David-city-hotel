USE david_city;
INSERT INTO properties (id,name,city,address,description,price,stars,badge,active) VALUES
(1,'Heliconia Park Lagos Luxury Hotel and Spa','Lagos','Ikoyi, Lagos, Nigeria','Illustrative luxury hotel listing. Not a live offer.',364152,5,'Popular',TRUE),
(2,'home of luxurious','Lagos','Lekki Phase 1, Lagos, Nigeria','Illustrative apartment listing. Not a live offer.',465838,4,NULL,TRUE),
(3,'The Lagos Continental Hotel','Lagos','Victoria Island, Lagos, Nigeria','Illustrative city hotel listing. Not a live offer.',298000,5,'Sample pick',TRUE),
(4,'Lekki Waterfront Apartment','Lagos','Lekki, Lagos, Nigeria','Illustrative apartment listing. Not a live offer.',185000,3,'Good value',TRUE),
(5,'Eko Pearl Towers Apartments','Lagos','Eko Atlantic City, Lagos, Nigeria','Illustrative apartment listing. Not a live offer.',510000,5,'Apartment',TRUE)
ON DUPLICATE KEY UPDATE name=VALUES(name), price=VALUES(price);

INSERT INTO property_images(property_id,image_url,alt_text,sort_order) VALUES
(1,'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=1000&q=80','Hotel exterior and pool',1),
(2,'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1000&q=80','Luxury apartment interior',1),
(3,'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1000&q=80','City hotel',1),
(4,'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1000&q=80','Modern apartment',1),
(5,'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1000&q=80','Apartment living room',1)
ON DUPLICATE KEY UPDATE image_url=VALUES(image_url);

INSERT INTO rooms(property_id,name,max_guests,nightly_rate,active) VALUES
(1,'Deluxe room',2,364152,TRUE),(1,'Executive suite',2,425000,TRUE),
(2,'One-bedroom apartment',2,465838,TRUE),(2,'Two-bedroom apartment',4,525000,TRUE),
(3,'Classic room',2,298000,TRUE),(4,'Studio apartment',2,185000,TRUE),(5,'Premium apartment',2,510000,TRUE);

-- Create a sample 90-day inventory window. Re-run only if you intend to refresh demo inventory.
INSERT IGNORE INTO room_inventory(room_id,inventory_date,available_rooms)
WITH RECURSIVE dates AS (
 SELECT CURRENT_DATE AS d
 UNION ALL SELECT DATE_ADD(d, INTERVAL 1 DAY) FROM dates WHERE d < DATE_ADD(CURRENT_DATE, INTERVAL 90 DAY)
)
SELECT r.id, dates.d, 2 FROM rooms r CROSS JOIN dates;
