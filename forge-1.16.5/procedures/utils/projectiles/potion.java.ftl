<@addTemplate file="utils/projectiles/projectile.java.ftl"/>
private static ProjectileEntity createPotionProjectile(World level, ItemStack contents, Entity shooter, Vector3d acceleration) {
	PotionEntity entityToSpawn = new PotionEntity(EntityType.POTION, level);
	entityToSpawn.setItem(contents);
	return initProjectileProperties(entityToSpawn, shooter, acceleration);
}