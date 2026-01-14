exports.getPrice = (req, res) => {
  const { pickup, dropoff, vehicleType } = req.body;

  // BASIC pricing logic (temporary)
  let baseFare = 5; // £
  let perKm = 2;    // £ per km (fake for now)

  // Fake distance logic (later we use Google Maps)
  let estimatedDistanceKm = 12;

  // Vehicle multiplier
  let multiplier = 1;
  if (vehicleType === 'van') multiplier = 1.5;
  if (vehicleType === 'minibus') multiplier = 2;

  const price =
    (baseFare + estimatedDistanceKm * perKm) * multiplier;

  res.json({
    success: true,
    price: price.toFixed(2),
    currency: "GBP",
  });
};
