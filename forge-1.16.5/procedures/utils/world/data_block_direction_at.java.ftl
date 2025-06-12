private static Direction getBlockDirection(IWorld world, BlockPos pos) {
	BlockState blockState = world.getBlockState(pos);
	Property<?> property = blockState.getBlock().getStateContainer().getProperty("facing");
	if (property != null && blockState.get(property) instanceof Direction)
		return ((Direction) blockState.get(property));
	else if (blockState.hasProperty(BlockStateProperties.AXIS))
		return Direction.getFacingFromAxisDirection(blockState.get(BlockStateProperties.AXIS), Direction.AxisDirection.POSITIVE);
	else if (blockState.hasProperty(BlockStateProperties.HORIZONTAL_AXIS))
		return Direction.getFacingFromAxisDirection(blockState.get(BlockStateProperties.HORIZONTAL_AXIS), Direction.AxisDirection.POSITIVE);
	return Direction.NORTH;
}