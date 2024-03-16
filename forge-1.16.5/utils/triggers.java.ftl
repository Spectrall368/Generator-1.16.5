<#include "procedures.java.ftl">

<#-- Item-related triggers -->
<#macro addSpecialInformation procedure="" isBlock=false>
	<#if procedure?has_content>
		@Override @OnlyIn(Dist.CLIENT) public void addInformation(ItemStack itemstack, <#if isBlock>IBlockReader<#else>World</#if> world, List<ITextComponent> list, ITooltipFlag flag) {
		super.addInformation(itemstack, world, list, flag);
		<#list procedure as entry>
		list.add(new StringTextComponent("${JavaConventions.escapeStringForJava(entry)}"));
		</#list>
		}
	</#if>
</#macro>

<#macro onEntitySwing procedure="">
<#if hasProcedure(procedure)>
@Override public boolean onEntitySwing(ItemStack itemstack, LivingEntity entity) {
	boolean retval = super.onEntitySwing(itemstack, entity);
	<@procedureCode procedure, {
		"x": "entity.getPosX()",
		"y": "entity.getPosY()",
		"z": "entity.getPosZ()",
		"world": "entity.world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
	return retval;
}
</#if>
</#macro>

<#macro onCrafted procedure="">
<#if hasProcedure(procedure)>
@Override public void onCreated(ItemStack itemstack, World world, PlayerEntity entity) {
	super.onCreated(itemstack, world, entity);
	<@procedureCode data.onCrafted, {
		"x": "entity.getPosX()",
		"y": "entity.getPosY()",
		"z": "entity.getPosZ()",
		"world": "world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
}
</#if>
</#macro>

<#macro onStoppedUsing procedure="">
<#if hasProcedure(procedure)>
@Override public void onPlayerStoppedUsing(ItemStack itemstack, World world, LivingEntity entity, int time) {
	super.onPlayerStoppedUsing(itemstack,world,entity,time);
	<@procedureCode data.onStoppedUsing, {
		"x": "entity.getPosX()",
		"y": "entity.getPosY()",
		"z": "entity.getPosZ()",
		"world": "world",
		"entity": "entity",
		"itemstack": "itemstack",
		"time": "time"
	}/>
}
</#if>
</#macro>

<#macro onEntityHitWith procedure="" hurtStack=false>
<#if hasProcedure(procedure) || hurtStack>
@Override public boolean hitEntity(ItemStack itemstack, LivingEntity entity, LivingEntity sourceentity) {
	<#if hurtStack>
		itemstack.damageItem(2, entity, i -> i.sendBreakAnimation(EquipmentSlotType.MAINHAND));
	<#else>
		boolean retval = super.hitEntity(itemstack, entity, sourceentity);
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
			"x": "entity.getPosX()",
			"y": "entity.getPosY()",
			"z": "entity.getPosZ()",
			"world": "entity.world",
			"entity": "entity",
			"sourceentity": "sourceentity",
			"itemstack": "itemstack"
		}/>
	</#if>
	return <#if hurtStack>true<#else>retval</#if>;
}
</#if>
</#macro>

<#macro onBlockDestroyedWith procedure="" hurtStack=false>
<#if hasProcedure(procedure) || hurtStack>
@Override public boolean onBlockDestroyed(ItemStack itemstack, World world, BlockState blockstate, BlockPos pos, LivingEntity entity) {
	<#if hurtStack>
		itemstack.damageItem(1, entity, i -> i.sendBreakAnimation(EquipmentSlotType.MAINHAND));
	<#else>
		boolean retval = super.onBlockDestroyed(itemstack,world,blockstate,pos,entity);
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
			"x": "pos.getPosX()",
			"y": "pos.getPosY()",
			"z": "pos.getPosZ()",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"blockstate": "blockstate"
		}/>
	</#if>
	return <#if hurtStack>true<#else>retval</#if>;
}
</#if>
</#macro>

<#macro onRightClickedInAir procedure="">
<#if hasProcedure(procedure)>
@Override public ActionResult<ItemStack> onItemRightClick(World world, PlayerEntity entity, Hand hand) {
	ActionResult<ItemStack> ar = super.onItemRightClick(world, entity, hand);
	<@procedureCode procedure, {
		"x": "entity.getPosX()",
		"y": "entity.getPosY()",
		"z": "entity.getPosZ()",
		"world": "world",
		"entity": "entity",
		"itemstack": "ar.getResult()"
	}/>
	return ar;
}
</#if>
</#macro>

<#macro onItemTick inUseProcedure="" inInvProcedure="">
<#if hasProcedure(inUseProcedure) || hasProcedure(inInvProcedure)>
@Override public void inventoryTick(ItemStack itemstack, World world, Entity entity, int slot, boolean selected) {
	super.inventoryTick(itemstack, world, entity, slot, selected);
	<#if hasProcedure(inUseProcedure)>
	if (selected)
		<@procedureCode inUseProcedure, {
			"x": "entity.getPosX()",
			"y": "entity.getPosY()",
			"z": "entity.getPosZ()",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"slot": "slot"
		}/>
	</#if>
	<#if hasProcedure(inInvProcedure)>
		<@procedureCode inInvProcedure, {
			"x": "entity.getPosX()",
			"y": "entity.getPosY()",
			"z": "entity.getPosZ()",
			"world": "world",
			"entity": "entity",
			"itemstack": "itemstack",
			"slot": "slot"
		}/>
	</#if>
}
</#if>
</#macro>

<#macro onDroppedByPlayer procedure="">
<#if hasProcedure(procedure)>
@Override public boolean onDroppedByPlayer(ItemStack itemstack, PlayerEntity entity) {
	<@procedureCode procedure, {
		"x": "entity.getPosX()",
		"y": "entity.getPosY()",
		"z": "entity.getPosZ()",
		"world": "entity.world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
	return true;
}
</#if>
</#macro>

<#macro onItemUsedOnBlock procedure="">
<#if hasProcedure(procedure)>
@Override public ActionResultType onItemUseFirst(ItemStack stack, ItemUseContext context) {
	super.onItemUseFirst(stack, context);
	<@procedureCodeWithOptResult procedure, "actionresulttype", "ActionResultType.SUCCESS", {
		"world": "context.getWorld()",
		"x": "context.getPos().getX()",
		"y": "context.getPos().getY()",
		"z": "context.getPos().getZ()",
		"blockstate": "context.getWorld().getBlockState(context.getPos())",
		"entity": "context.getPlayer()",
		"direction": "context.getFace()",
		"itemstack": "context.getItem()"
	}/>
}
</#if>
</#macro>

<#macro hasGlow procedure="">
@Override @OnlyIn(Dist.CLIENT) public boolean hasEffect(ItemStack itemstack) {
	<#if hasProcedure(procedure)>
		<#assign dependencies = procedure.getDependencies(generator.getWorkspace())>
		<#if !(dependencies.isEmpty() || (dependencies.size() == 1 && dependencies.get(0).getName() == "itemstack"))>
		Entity entity = Minecraft.getInstance().player;
		</#if>
		return <@procedureCode procedure, {
			"x": "entity.getPosX()",
			"y": "entity.getPosY()",
			"z": "entity.getPosZ()",
			"entity": "entity",
			"world": "entity.world",
			"itemstack": "itemstack"
		}/>
	<#else>
		return true;
	</#if>
}
</#macro>

<#-- Armor triggers -->
<#macro onArmorTick procedure="">
<#if hasProcedure(procedure)>
@Override public void onArmorTick(ItemStack itemstack, World world, PlayerEntity entity) {
	super.onArmorTick(itemstack, world, entity);
	<@procedureCode procedure, {
		"x": "entity.getPosX()",
		"y": "entity.getPosY()",
		"z": "entity.getPosZ()",
		"world": "world",
		"entity": "entity",
		"itemstack": "itemstack"
	}/>
}
</#if>
</#macro>

<#-- Block-related triggers -->
<#macro onDestroyedByPlayer procedure="">
<#if hasProcedure(procedure)>
@Override public boolean removedByPlayer(BlockState blockstate, World world, BlockPos pos, PlayerEntity entity, boolean willHarvest, IFluidState fluid) {
	boolean retval = super.removedByPlayer(blockstate, world, pos, entity, willHarvest, fluid);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "blockstate"
	}/>
	return retval;
}
</#if>
</#macro>

<#macro onDestroyedByExplosion procedure="">
<#if hasProcedure(procedure)>
@Override public void onExplosionDestroy(World world, BlockPos pos, Explosion e) {
	super.onExplosionDestroy(world, pos, e);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world"
	}/>
}
</#if>
</#macro>

<#macro onEntityCollides procedure="">
<#if hasProcedure(procedure)>
@Override public void onEntityCollision(BlockState blockstate, World world, BlockPos pos, Entity entity) {
	super.onEntityCollision(blockstate, world, pos, entity);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "blockstate"
	}/>
}
</#if>
</#macro>

<#macro onBlockAdded procedure="" scheduleTick=false tickRate=0>
<#if scheduleTick || hasProcedure(procedure)>
@Override public void onBlockAdded(BlockState blockstate, World world, BlockPos pos, BlockState oldState, boolean moving) {
	super.onBlockAdded(blockstate, world, pos, oldState, moving);
	<#if scheduleTick>
		world.getPendingBlockTicks().scheduleTick(pos, this, ${tickRate});
	</#if>
	<#if hasProcedure(procedure)>
		<@procedureCode procedure, {
		"x": "pos.getX()",
		"y": "pos.getY()",
		"z": "pos.getZ()",
		"world": "world",
		"blockstate": "blockstate",
		"oldState": "oldState",
		"moving": "moving"
		}/>
	</#if>
}
</#if>
</#macro>

<#macro onEntityWalksOn procedure="">
<#if hasProcedure(procedure)>
@Override public void onEntityWalk(World world, BlockPos pos, Entity entity) {
	super.onEntityWalk(world, pos, entity);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "world.getBlockState(pos)"
	}/>
}
</#if>
</#macro>

<#macro onBlockPlacedBy procedure="">
<#if hasProcedure(procedure)>
@Override public void onBlockPlacedBy(World world, BlockPos pos, BlockState blockstate, LivingEntity entity, ItemStack itemstack) {
	super.onBlockPlacedBy(world, pos, blockstate, entity, itemstack);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "blockstate",
	"itemstack": "itemstack"
	}/>
}
</#if>
</#macro>

<#macro onStartToDestroy procedure="">
<#if hasProcedure(procedure)>
@Override public void onBlockClicked(BlockState blockstate, World world, BlockPos pos, PlayerEntity entity) {
	super.onBlockClicked(blockstate, world, pos, entity);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "entity",
	"blockstate": "blockstate"
	}/>
}
</#if>
</#macro>

<#macro onRedstoneOrNeighborChanged onRedstoneOn="" onRedstoneOff="" onNeighborChanged="">
<#if hasProcedure(onRedstoneOn) || hasProcedure(onRedstoneOff) || hasProcedure(onNeighborChanged)>
@Override public void neighborChanged(BlockState blockstate, World world, BlockPos pos, Block neighborBlock, BlockPos fromPos, boolean moving) {
	super.neighborChanged(blockstate, world, pos, neighborBlock, fromPos, moving);
	<#if hasProcedure(onRedstoneOn) || hasProcedure(onRedstoneOff)>
		if (world.getRedstonePowerFromNeighbors(pos) > 0) {
		<#if hasProcedure(onRedstoneOn)>
			<@procedureCode onRedstoneOn, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
			}/>
		</#if>
		}
		<#if hasProcedure(onRedstoneOff)> else {
			<@procedureCode onRedstoneOff, {
			"x": "pos.getX()",
			"y": "pos.getY()",
			"z": "pos.getZ()",
			"world": "world",
			"blockstate": "blockstate"
			}/>
		}
		</#if>
	</#if>
	<#if hasProcedure(onNeighborChanged)>
		<@procedureCode onNeighborChanged, {
		"x": "pos.getX()",
		"y": "pos.getY()",
		"z": "pos.getZ()",
		"world": "world",
		"blockstate": "blockstate"
		}/>
	</#if>
}
</#if>
</#macro>

<#macro onAnimateTick procedure="">
<#if hasProcedure(procedure)>
@Override @OnlyIn(Dist.CLIENT) public void animateTick(BlockState blockstate, World world, BlockPos pos, Random random) {
	super.animateTick(blockstate, world, pos, random);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"entity": "Minecraft.getInstance().player",
	"blockstate": "blockstate"
	}/>
}
</#if>
</#macro>

<#macro onBlockTick procedure="" scheduleTick=false tickRate=0>
<#if hasProcedure(procedure)>
@Override public void tick(BlockState blockstate, ServerWorld world, BlockPos pos, Random random) {
	super.tick(blockstate, world, pos, random);
	<@procedureCode procedure, {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"blockstate": "blockstate"
	}/>
	<#if scheduleTick>
	world.getPendingBlockTicks().scheduleTick(pos, this, ${tickRate});
	</#if>
}
</#if>
</#macro>

<#macro onBlockRightClicked procedure="">
<#if hasProcedure(procedure)>
@Override public ActionResultType onBlockActivated(BlockState blockstate, World world, BlockPos pos, PlayerEntity entity, Hand hand, BlockRayTraceResult hit) {
	super.onBlockActivated(blockstate, world, pos, entity, hand, hit);
	<@procedureCodeWithOptResult procedure, "actionresulttype", "ActionResultType.SUCCESS", {
	"x": "pos.getX()",
	"y": "pos.getY()",
	"z": "pos.getZ()",
	"world": "world",
	"blockstate": "blockstate",
	"entity": "entity",
	"direction": "hit.getFace()",
	"hitX": "hit.getHitVec().x()",
	"hitY": "hit.getHitVec().y()",
	"hitZ": "hit.getHitVec().z()"
	}/>
}
</#if>
</#macro>

<#macro onHitByProjectile procedure="">
<#if hasProcedure(procedure)>
@Override public void onProjectileCollision(World world, BlockState blockstate, BlockRayTraceResult hit, Entity entity) {
	<@procedureCode procedure, {
	"x": "hit.getPos().getX()",
	"y": "hit.getPos().getY()",
	"z": "hit.getPos().getZ()",
	"world": "world",
	"blockstate": "blockstate",
	"entity": "entity",
	"direction": "hit.getFace()",
	"hitX": "hit.getHitVec().x()",
	"hitY": "hit.getHitVec().y()",
	"hitZ": "hit.getHitVec().z()"
	}/>
}
</#if>
</#macro>