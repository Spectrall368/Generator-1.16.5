<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
 # 
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 # 
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 # 
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 # 
 # Additional permission for code generator templates (*.ftl files)
 # 
 # As a special exception, you may create a larger work that contains part or 
 # all of the MCreator code generator templates (*.ftl files) and distribute 
 # that work under terms of your choice, so long as that work isn't itself a 
 # template for code generation. Alternatively, if you modify or redistribute 
 # the template itself, you may (at your option) remove this special exception, 
 # which will cause the template and the resulting code generator output files 
 # to be licensed under the GNU General Public License without this special 
 # exception.
-->

<#-- @formatter:off -->
<#include "../boundingboxes.java.ftl">
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">
<#include "../mcitems.ftl">
package ${package}.block;

import net.minecraft.block.material.Material;
import net.minecraft.util.SoundEvent;

<#compress>
public class ${name}Block extends <#if data.plantType == "normal">Flower<#elseif data.plantType == "growapable">SugarCane<#elseif data.plantType == "double">DoublePlant</#if>Block {
	public ${name}Block() {
		super(<#if data.plantType == "normal">${generator.map(data.suspiciousStewEffect, "effects")}, ${data.suspiciousStewDuration},</#if>
		<#if generator.map(data.colorOnMap, "mapcolors") != "DEFAULT">
		Block.Properties.create(Material.PLANTS, MaterialColor.${generator.map(data.colorOnMap, "mapcolors")})
		<#else>
		Block.Properties.create(Material.PLANTS)
		</#if>
		<#if data.plantType == "growapable" || data.forceTicking>
		.tickRandomly()
		</#if>
		<#if data.isCustomSoundType>
			.sound(new ForgeSoundType(1.0f, 1.0f, () -> new SoundEvent(new ResourceLocation("${data.breakSound}")),
			() -> new SoundEvent(new ResourceLocation("${data.stepSound}")),
			() -> new SoundEvent(new ResourceLocation("${data.placeSound}")),
			() -> new SoundEvent(new ResourceLocation("${data.hitSound}")),
			() -> new SoundEvent(new ResourceLocation("${data.fallSound}"))))
		<#else>
			.sound(SoundType.${data.soundOnStep})
		</#if>
		<#if data.unbreakable>
		.hardnessAndResistance(-1, 3600000)
		<#elseif (data.hardness == 0) && (data.resistance == 0)>
		.zeroHardnessAndResistance()
		<#elseif data.hardness == data.resistance>
		.hardnessAndResistance(${data.hardness}f)
		<#else>
		.hardnessAndResistance(${data.hardness}f, ${data.resistance}f)
		</#if>
		<#if data.emissiveRendering>
		.setNeedsPostProcessing((bs, br, bp) -> true).setEmmisiveRendering((bs, br, bp) -> true)
		</#if>
		<#if data.speedFactor != 1.0>
		.speedFactor(${data.speedFactor}f)
		</#if>
		<#if data.jumpFactor != 1.0>
		.jumpFactor(${data.jumpFactor}f)
		</#if>
		<#if data.luminance != 0>
		.setLightLevel(s -> ${data.luminance})
		</#if>
		<#if !data.useLootTableForDrops && (data.dropAmount == 0)>
		.noDrops()
		</#if>
		<#if data.isSolid>
		.notSolid()
			<#if (data.customBoundingBox && data.boundingBoxes??) || (data.offsetType != "NONE")>
			.variableOpacity()
			</#if>
		<#else>
		.doesNotBlockMovement()
		</#if>
		);
	}

	public static void clientLoad(FMLClientSetupEvent event) {
		RenderTypeLookup.setRenderLayer(${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get(), RenderType.getCutout());
	}

	<#if data.customBoundingBox && data.boundingBoxes??>
	@Override public VoxelShape getShape(BlockState state, IBlockReader world, BlockPos pos, ISelectionContext context) {
		<#if data.isBoundingBoxEmpty()>
			return VoxelShapes.empty();
		<#else>
			<#if !data.disableOffset> Vector3d offset = state.getOffset(world, pos); </#if>
			<@boundingBoxWithRotation data.positiveBoundingBoxes() data.negativeBoundingBoxes() data.disableOffset 0/>
		</#if>
	}
	</#if>

	<#if (data.plantType == "normal")>
		<#if (data.suspiciousStewDuration > 0)>
		@Override public int getStewEffectDuration() {
			return ${data.suspiciousStewDuration};
		}
		</#if>
		<#if data.suspiciousStewEffect?starts_with("CUSTOM:")>
		@Override public Effect getStewEffect() {
			return ${generator.map(data.suspiciousStewEffect, "effects")};
		}
		</#if>
	</#if>

	<#if data.isReplaceable>
	@Override public boolean isReplaceable(BlockState state, BlockItemUseContext useContext) {
		return useContext.getItem().getItem() != this.asItem();
	}
	</#if>

	<#if data.flammability != 0>
	@Override public int getFlammability(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.flammability};
	}
	</#if>

	<#if generator.map(data.aiPathNodeType, "pathnodetypes") != "DEFAULT">
	@Override public PathNodeType getAiPathNodeType(BlockState state, IBlockReader world, BlockPos pos, MobEntity entity) {
		return PathNodeType.${generator.map(data.aiPathNodeType, "pathnodetypes")};
	}
	</#if>

	<#if data.offsetType != "XZ">
	@Override public Block.OffsetType getOffsetType() {
		return Block.OffsetType.${data.offsetType};
	}
	</#if>

	<@addSpecialInformation data.specialInfo, true/>

	<#if data.fireSpreadSpeed != 0>
	@Override public int getFireSpreadSpeed(BlockState state, IBlockReader world, BlockPos pos, Direction face) {
		return ${data.fireSpreadSpeed};
	}
	</#if>

	<#if data.creativePickItem?? && !data.creativePickItem.isEmpty()>
	@Override public ItemStack getPickBlock(BlockState state, RayTraceResult target, IBlockReader world, BlockPos pos, PlayerEntity player) {
		return ${mappedMCItemToItemStackCode(data.creativePickItem, 1)};
	}
	</#if>

	<#if !(data.useLootTableForDrops || (data.dropAmount == 0))>
		<#if data.dropAmount != 1 && !(data.customDrop?? && !data.customDrop.isEmpty())>
		@Override public List<ItemStack> getDrops(BlockState state, LootContext.Builder builder) {
			<#if data.plantType == "double">
			if(state.get(BlockStateProperties.DOUBLE_BLOCK_HALF) != DoubleBlockHalf.LOWER)
				return Collections.emptyList();
			</#if>

			List<ItemStack> dropsOriginal = super.getDrops(state, builder);
			if(!dropsOriginal.isEmpty())
				return dropsOriginal;
			return Collections.singletonList(new ItemStack(this, ${data.dropAmount}));
		}
		<#elseif data.customDrop?? && !data.customDrop.isEmpty()>
		@Override public List<ItemStack> getDrops(BlockState state, LootContext.Builder builder) {
			<#if data.plantType == "double">
			if(state.get(BlockStateProperties.DOUBLE_BLOCK_HALF) != DoubleBlockHalf.LOWER)
				return Collections.emptyList();
			</#if>

			List<ItemStack> dropsOriginal = super.getDrops(state, builder);
			if(!dropsOriginal.isEmpty())
				return dropsOriginal;
			return Collections.singletonList(${mappedMCItemToItemStackCode(data.customDrop, data.dropAmount)});
		}
		<#else>
		@Override public List<ItemStack> getDrops(BlockState state, LootContext.Builder builder) {
			<#if data.plantType == "double">
			if(state.get(BlockStateProperties.DOUBLE_BLOCK_HALF) != DoubleBlockHalf.LOWER)
				return Collections.emptyList();
			</#if>

			List<ItemStack> dropsOriginal = super.getDrops(state, builder);
			if(!dropsOriginal.isEmpty())
				return dropsOriginal;
			return Collections.singletonList(new ItemStack(this, 1));
		}
		</#if>
	</#if>

	<#if (data.canBePlacedOn?size > 0) || hasProcedure(data.placingCondition)>
		<#if data.plantType != "growapable">
		@Override public boolean isValidGround(BlockState groundState, IBlockReader worldIn, BlockPos pos) {
			<#if hasProcedure(data.placingCondition)>
			boolean additionalCondition = true;
			if (worldIn instanceof IWorld) {
				IWorld world = (IWorld) worldIn;
				int x = pos.getX();
				int y = pos.getY() + 1;
				int z = pos.getZ();
				BlockState blockstate = world.getBlockState(pos.up());
				additionalCondition = <@procedureOBJToConditionCode data.placingCondition/>;
			}
			</#if>

			return
			<#if (data.canBePlacedOn?size > 0)>
				<@canPlaceOnList data.canBePlacedOn hasProcedure(data.placingCondition)/>
			</#if>
			<#if (data.canBePlacedOn?size > 0) && hasProcedure(data.placingCondition)> && </#if>
			<#if hasProcedure(data.placingCondition)> additionalCondition </#if>;
		}
		</#if>

		@Override public boolean isValidPosition(BlockState blockstate, IWorldReader worldIn, BlockPos pos) {
			BlockPos blockpos = pos.down();
			BlockState groundState = worldIn.getBlockState(blockpos);

			<#if data.plantType = "normal">
				return this.isValidGround(groundState, worldIn, blockpos)
			<#elseif data.plantType == "growapable">
				<#if hasProcedure(data.placingCondition)>
				boolean additionalCondition = true;
				if (worldIn instanceof IWorld) {
					IWorld world = (IWorld) worldIn;
					int x = pos.getX();
					int y = pos.getY();
					int z = pos.getZ();
					additionalCondition = <@procedureOBJToConditionCode data.placingCondition/>;
				}
				</#if>

				return groundState.getBlock() == this ||
				<#if (data.canBePlacedOn?size > 0)>
					<@canPlaceOnList data.canBePlacedOn hasProcedure(data.placingCondition)/>
				</#if>
				<#if (data.canBePlacedOn?size > 0) && hasProcedure(data.placingCondition)> && </#if>
				<#if hasProcedure(data.placingCondition)> additionalCondition </#if>
			<#else>
				if (blockstate.get(HALF) == DoubleBlockHalf.UPPER)
					return groundState.isIn(this) && groundState.get(HALF) == DoubleBlockHalf.LOWER;
				else
					return this.isValidGround(groundState, worldIn, blockpos)
			</#if>;
		}
	</#if>

	<#if !(data.growapableSpawnType == "Plains" && data.plantType == "normal")>
	@Override public PlantType getPlantType(IBlockReader world, BlockPos pos) {
		return PlantType.${generator.map(data.growapableSpawnType, "planttypes")};
	}
	</#if>

	<@onBlockAdded data.onBlockAdded, false, 0/>

	<#if data.plantType == "growapable" || hasProcedure(data.onTickUpdate)>
	@Override public void randomTick(BlockState blockstate, ServerWorld world, BlockPos pos, Random random) {
		<#if data.plantType == "growapable">
		if (world.isAirBlock(pos.up())) {
			int i = 1;
			for(;world.getBlockState(pos.down(i)).getBlock() == this; ++i);
			if (i < ${data.growapableMaxHeight}) {
				int j = blockstate.get(AGE);
				if (ForgeHooks.onCropsGrowPre(world, pos, blockstate, true)) {
					if (j == 15) {
						world.setBlockState(pos.up(), getDefaultState());
						world.setBlockState(pos, blockstate.with(AGE, 0), 4);
					} else {
						world.setBlockState(pos, blockstate.with(AGE, j + 1), 4);
					}
				}
			}
		}
		</#if>

		<#if hasProcedure(data.onTickUpdate)>
			<@procedureCode data.onTickUpdate, {
			"x": "pos.getPosX()",
			"y": "pos.getPosY()",
			"z": "pos.getPosZ()",
			"world": "world",
			"blockstate": "blockstate"
			}/>
		</#if>
	}
	</#if>

	<@onAnimateTick data.onRandomUpdateEvent/>

	<@onRedstoneOrNeighborChanged "", "", data.onNeighbourBlockChanges/>

	<@onEntityCollides data.onEntityCollides/>

	<@onDestroyedByPlayer data.onDestroyedByPlayer/>

	<@onDestroyedByExplosion data.onDestroyedByExplosion/>

	<@onStartToDestroy data.onStartToDestroy/>

	<@onBlockPlacedBy data.onBlockPlacedBy/>

	<@onBlockRightClicked data.onRightClicked/>

	<@onEntityWalksOn data.onEntityWalksOn/>

	<@onHitByProjectile data.onHitByProjectile/>

	<#if data.hasTileEntity>
	@Override public boolean hasTileEntity(BlockState state) {
		return true;
	}

	@Override public TileEntity createTileEntity(BlockState state, IBlockReader world) {
		return new ${name}BlockEntity();
	}

	@Override public boolean eventReceived(BlockState state, World world, BlockPos pos, int eventID, int eventParam) {
		super.eventReceived(state, world, pos, eventID, eventParam);
		TileEntity blockEntity = world.getTileEntity(pos);
		return blockEntity == null ? false : blockEntity.receiveClientEvent(eventID, eventParam);
	}
	</#if>

	<#if data.tintType != "No tint">
		@OnlyIn(Dist.CLIENT) public static void blockColorLoad(ColorHandlerEvent.Block event) {
			event.getBlockColors().register((bs, world, pos, index) -> {
				<#if data.tintType == "Default foliage">
					return FoliageColors.getDefault();
				<#elseif data.tintType == "Birch foliage">
					return FoliageColors.getBirch();
				<#elseif data.tintType == "Spruce foliage">
					return FoliageColors.getSpruce();
				<#else>
					return world != null && pos != null ?
					<#if data.tintType == "Grass">
						BiomeColors.getGrassColor(world, pos) : GrassColors.get(0.5D, 1.0D);
					<#elseif data.tintType == "Foliage">
						BiomeColors.getFoliageColor(world, pos) : FoliageColors.getDefault();
					<#elseif data.tintType == "Water">
						BiomeColors.getWaterColor(world, pos) : -1;
					<#elseif data.tintType == "Sky">
						Minecraft.getInstance().level.getBiome(pos).value().getSkyColor() : 8562943;
					<#elseif data.tintType == "Fog">
						Minecraft.getInstance().level.getBiome(pos).value().getFogColor() : 12638463;
					<#else>
						Minecraft.getInstance().level.getBiome(pos).value().getWaterFogColor() : 329011;
					</#if>
				</#if>
			}, ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get());
		}

		<#if data.isItemTinted>
		@OnlyIn(Dist.CLIENT) public static void itemColorLoad(ColorHandlerEvent.Item event) {
			event.getItemColors().register((stack, index) -> {
				<#if data.tintType == "Grass">
					return GrassColors.get(0.5D, 1.0D);
				<#elseif data.tintType == "Foliage" || data.tintType == "Default foliage">
					return FoliageColors.getDefault();
				<#elseif data.tintType == "Birch foliage">
					return FoliageColors.getBirch();
				<#elseif data.tintType == "Spruce foliage">
					return FoliageColors.getSpruce();
				<#elseif data.tintType == "Water">
					return 3694022;
				<#elseif data.tintType == "Sky">
					return 8562943;
				<#elseif data.tintType == "Fog">
					return 12638463;
				<#else>
					return 329011;
				</#if>
			}, ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get());
		}
		</#if>
	</#if>
}
</#compress>
<#-- @formatter:on -->
<#macro canPlaceOnList blockList condition>
<#if (blockList?size > 1) && condition>(</#if>
<#list blockList as canBePlacedOn>
groundState.getBlock() == (${mappedBlockToBlock(canBePlacedOn)})<#sep>||
</#list><#if (blockList?size > 1) && condition>)</#if>
</#macro>
