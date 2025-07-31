private static Entity spawnEntity(Entity entity, BlockPos blockpos, IWorld world) {
    entity.setPosition(blockpos.getX(), blockpos.getY(), blockpos.getZ());

    if (entity instanceof MobEntity)
        ((MobEntity) entity).onInitialSpawn((ServerWorld) world, world.getDifficultyForLocation(entity.getPosition()), SpawnReason.MOB_SUMMONED, null, null);

    world.addEntity(entity);
    return entity;
}