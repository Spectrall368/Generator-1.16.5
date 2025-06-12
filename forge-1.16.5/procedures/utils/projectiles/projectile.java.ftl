private static ProjectileEntity initProjectileProperties(ProjectileEntity entityToSpawn, Entity shooter, Vector3d acceleration) {
	entityToSpawn.setShooter(shooter);
	if (!Vector3d.ZERO.equals(acceleration)) {
		entityToSpawn.setMotion(acceleration);
		entityToSpawn.isAirBorne = true;
	}
	return entityToSpawn;
}