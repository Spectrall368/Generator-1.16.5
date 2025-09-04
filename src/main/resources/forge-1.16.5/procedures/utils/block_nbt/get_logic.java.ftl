private static boolean getBlockNBTLogic(IWorld world, BlockPos pos, String tag) {
	TileEntity blockEntity = world.getTileEntity(pos);
	if (blockEntity != null)
		return blockEntity.getTileData().getBoolean(tag);
	return false;
}