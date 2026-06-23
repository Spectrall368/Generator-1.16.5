private static Entity getEntityFromUUID(ServerWorld level, String uuid) {
    try {
        return level.getEntityByUuid(UUID.fromString(uuid));
    } catch (IllegalArgumentException e) {
        return null;
    }
}