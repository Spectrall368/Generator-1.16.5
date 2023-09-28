<#macro bonemealEvents isBonemealTargetCondition="" bonemealSuccessCondition="" onBonemealSuccess="">
@Override public boolean canGrow(IBlockReader worldIn, BlockPos pos, BlockState blockstate, boolean clientSide) {
	<#if hasProcedure(isBonemealTargetCondition)>
	if (worldIn instanceof IWorld world) {
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();
		return <@procedureOBJToConditionCode isBonemealTargetCondition/>;
	}
	return false;
	<#else>
	return true;
	</#if>
}

@Override public boolean canUseBonemeal(World world, Random random, BlockPos pos, BlockState blockstate) {
	<#if hasProcedure(bonemealSuccessCondition)>
		int x = pos.getX();
		int y = pos.getY();
		int z = pos.getZ();
		return <@procedureOBJToConditionCode bonemealSuccessCondition/>;
	<#else>
	return true;
	</#if>
}

@Override public void grow(ServerWorld worldIn, Random random, BlockPos pos, BlockState state) {
	<#if hasProcedure(onBonemealSuccess)>
	int x = pos.getX();
	int y = pos.getY();
	int z = pos.getZ();
	World world = (World) worldIn;
	BlockState blockstate = world.getBlockState(pos);
        return <@procedureOBJToConditionCode onBonemealSuccess/>;
	</#if>
}
</#macro>
