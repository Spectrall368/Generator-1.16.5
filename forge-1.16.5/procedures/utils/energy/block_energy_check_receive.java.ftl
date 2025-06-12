private static int receiveEnergySimulate(IWorld level, BlockPos pos, int amount, Direction direction) {
    AtomicInteger result = new AtomicInteger(0);
    TileEntity entity = level.getTileEntity(pos);
    if (entity != null)
        entity.getCapability(CapabilityEnergy.ENERGY, direction)
		    .ifPresent(capability -> result.set(capability.receiveEnergy(amount, true)));

	return result.get();
}