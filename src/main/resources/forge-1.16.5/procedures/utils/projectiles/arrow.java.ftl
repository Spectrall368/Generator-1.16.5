private static AbstractArrowEntity initArrowProjectile(AbstractArrowEntity entityToSpawn, Entity shooter, float damage, boolean silent, boolean fire, boolean particles, AbstractArrowEntity.PickupStatus pickup) {
	entityToSpawn.setShooter(shooter);
	entityToSpawn.setDamage(damage);
	if (silent)
		entityToSpawn.setSilent(true);
	if (fire)
		entityToSpawn.setFire(100);
	if (particles)
		entityToSpawn.setIsCritical(true);
	entityToSpawn.pickupStatus = pickup;
	return entityToSpawn;
}