  # 🛠️ API & Integration Fixes: Restaurant Module

Yeh document Frontend aur Backend ke beech ke current logical gaps aur mismatch
ko address karta hai. In changes ka main objective **Performance Optimization**
aur **Feature Completion** hai.

---

## 1. Payload Size Optimization (List API)

**Issue:** `getNearbyRestaurants` API response ka size bohot bada ho raha hai.

- **Problem:** API har restaurant ke saath puri `foodsImages` ka array bhej rahi
  hai. Agar 20 restaurants hain aur har ek mein 10 images hain, toh response
  size MBs mein chala jata hai, jisse App slow ho jati hai.
- **Action Required:** - **File:** `restaurant.controller.js`
  - **Function:** `getNearbyRestaurants`
  - **Fix:** Structured Projection (Pipeline Stage) mein `foodsImages` ko remove
    karein. Sirf `restaurantImages` ka pehla index (Cover Photo) hi bhejna hai.

---

## 2. Dynamic Computed Keys (UI Requirements)

**Issue:** Frontend ko badges aur icons show karne ke liye extra computed fields
chahiye jo abhi missing hain.

- **Problem:** Frontend ko `isFavourite` aur `distanceText` calculate karne ke
  liye loop chalana pad raha hai, jisse App lag kar rahi hai (O(N^2)
  complexity).
- **Action Required:**
  - **isFavourite:** User model se current user ke `favourites` array ko
    `$lookup` ya query ke through match karein aur `Boolean` bhejें.
  - **Distance Text:** Agar distance < 10km hai toh "Away" aur > 10km hai toh
    "Far Away" ka string append karein.
  - **Cuisine:** Green tag display ke liye `cuisine` key ko response ke
    top-level par ensure karein.

---

## 3. Search & Multi-Filter Logic Connection

**Issue:** Bottom sheet filters (Cuisine, Rating, Halal) backend API se
connected nahi hain.

- **Problem:** Abhi API sirf static strings (`top_rated`, `open_now`) handle kar
  rahi hai. Frontend se aane wale multiple params ignore ho rahe hain.
- **Action Required:**
  - **Function:** `getNearbyRestaurants`
  - **Fix:** `req.query` se `cuisine`, `minRating`, aur `isHalal` ko extract
    karein aur inhe dynamic `searchQuery` object mein build karein.
  - **Logic:** `matchQuery.cuisine = new RegExp(cuisine, "i")` aur
    `matchQuery["rating.average"] = { $gte: minRating }`.

---

## 4. Geo-Location & Radius Filter (Distance Logic)

**Issue:** `$geoNear` pipeline disabled hai, jisse real-time distance
calculation fail ho raha hai.

- **Problem:** Parameter ka naam mismatch hai (Frontend `distance` bhej raha
  hai, Backend `radius` expect kar sakta hai). Real-time location base search
  kaam nahi kar rahi.
- **Action Required:**
  - **Fix:** Pipeline ki **1st Stage** mein `$geoNear` ko wapas active karein.
  - **Parameter:** Query param ka naam fix karke `distance` rakhein (in KM).
  - **Conversion:** `maxDistance` mein `distance * 1000` (meters) pass karein.

---

## 5. Key Name Mismatch: Add Restaurant API

**Issue:** Frontend "restaurantImages" bhej raha hai par Backend "foodsImages"
expect kar raha hai.

- **Problem:** Key mismatch ki wajah se Joi validation fail ho rahi hai (400 Bad
  Request).
- **Action Required:**
  - **Files:** `restaurant.validation.js` & `restaurant.controller.js`
  - **Function:** `addRestaurantByRequest`
  - **Fix:** Joi schema aur Controller saving logic dono jagah `foodsImages` ka
    naam badal kar `restaurantImages` karein.

---

## 📈 Impact Table

| Feature                  | Fix Type      | Impact on App              |
| :----------------------- | :------------ | :------------------------- |
| **Payload Optimization** | Performance   | 70% faster initial load    |
| **Computed Keys**        | Performance   | Smooth scrolling (no lag)  |
| **Multi-Filters**        | Functionality | Correct search results     |
| **Geo-Location**         | UX            | Accurate "Nearby" sorting  |
| **Key Renaming**         | Bug Fix       | Successful data submission |

---

## Next Steps for Backend:

1. Update the `projection` stage in the aggregation pipeline.
2. Re-enable the `$geoNear` stage as the mandatory first stage.
3. Align the Joi validation keys with the frontend payload.

---

# Solution for above issues:

# 📍 Nearby Restaurants API Documentation

Is API ka use User ki current location (Latitude/Longitude) ke aadhar par
restaurants fetch karne ke liye kiya jata hai. Isme advanced filtering, caching,
aur dynamic geospatial sorting included hai.

### 🔗 Endpoint URL

`GET {{BASE_URL}}/api/v1/restaurants/nearbyrestaurants?page=1&limit=20&cuisine=Pan-Asian&search=Mamloca&minRating=4&filter=open_now&lng=75.8896&lat=22.768&distance=5`

---

### 📥 Query Parameters Detail

| Parameter     | Type   | Description                                                       |
| :------------ | :----- | :---------------------------------------------------------------- |
| `lat` / `lng` | Float  | User ki current GPS coordinates (Mandatory for distance sorting). |
| `distance`    | Number | Search radius (e.g., 5 represents 5km).                           |
| `search`      | String | Restaurant name ya address search karne ke liye.                  |
| `cuisine`     | String | Specific food category (e.g., Pan-Asian).                         |
| `minRating`   | Number | Minimum rating filter (e.g., 4 star and above).                   |
| `filter`      | String | Pre-defined filters like `open_now`, `top_rated`, `certified`.    |

---

### 📤 Sample JSON Response

```json
{
  "success": true,
  "fromCache": false,
  "metadata": {
    "page": 1,
    "limit": 20,
    "count": 1,
    "distanceRange": "5km"
  },
  "message": "Restaurants fetched successfully",
  "data": [
    {
      "_id": "694b90ae6b1a5c4429da14d6",
      "restaurantName": "New Mamloca",
      "cuisine": "Mediterranean, Pan-Asian",
      "address": {
        "fullAddress": "11th Floor, Apollo Premier, Vijay Nagar, Indore, MP 452010",
        "city": "Indore",
        "state": "MP",
        "country": "India",
        "pincode": "452010"
      },
      "location": {
        "type": "Point",
        "coordinates": [75.8851776, 22.7573171]
      },
      "phone": "+9112346567890",
      "isOpenNow": true,
      "isFavourite": true,
      "distanceInKm": "1.27km away",
      "metrics": {
        "avgRating": 4,
        "totalReviews": 2
      },
      "halalInfo": {
        "isCertified": false,
        "summary": "We offer a delightful menu of halal dishes..."
      },
      "restaurantImg": "[https://res.cloudinary.com/deawecub3/image/upload/v1766493549/Halal/restaurants/restaurant/restaurants2_1766493545636.jpg](https://res.cloudinary.com/deawecub3/image/upload/v1766493549/Halal/restaurants/restaurant/restaurants2_1766493545636.jpg)"
    }
  ]
}
```
