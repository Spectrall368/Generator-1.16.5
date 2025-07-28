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
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
package ${package}.entity;

<#compress>
@OnlyIn(value = Dist.CLIENT, _interface = IRendersAsItem.class)
public class ${name}Entity extends AbstractArrowEntity implements IRendersAsItem {

	public static final ItemStack PROJECTILE_ITEM = ${mappedMCItemToItemStackCode(data.projectileItem)};

	public ${name}Entity(FMLPlayMessages.SpawnEntity packet, World world) {
		super(${JavaModName}Entities.${REGISTRYNAME}.get(), world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	public ${name}Entity(EntityType<? extends ${name}Entity> type, World world) {
		super(type, world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	public ${name}Entity(EntityType<? extends ${name}Entity> type, double x, double y, double z, World world) {
		super(type, x, y, z, world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	public ${name}Entity(EntityType<? extends ${name}Entity> type, LivingEntity entity, World world) {
		super(type, entity, world);
		<#if data.disableGravity>
		setNoGravity(true);
		</#if>
	}

	@Override public IPacket<?> createSpawnPacket() {
		return NetworkHooks.getEntitySpawningPacket(this);
	}

	@Override @OnlyIn(Dist.CLIENT) public ItemStack getItem() {
		return PROJECTILE_ITEM;
	}

	@Override protected ItemStack getArrowStack() {
		return PROJECTILE_ITEM;
	}

	@Override protected void arrowHit(LivingEntity entity) {
		super.arrowHit(entity);
		entity.setArrowCountInEntity(entity.getArrowCountInEntity() - 1); <#-- #53957 -->
	}

	<#if (data.modelWidth > 0.5) || (data.modelHeight > 0.5)>
	@Nullable @Override protected EntityRayTraceResult rayTraceEntities(Vector3d projectilePosition, Vector3d deltaPosition) {
		double d0 = Double.MAX_VALUE;
		Entity entity = null;
		AxisAlignedBB lookupBox = this.getBoundingBox();
		for (Entity entity1 : this.world.getEntitiesInAABBexcluding(this, lookupBox, this::func_230298_a_)) {
			if (entity1 == this.func_234616_v_()) continue;
			AxisAlignedBB aabb = entity1.getBoundingBox();
			if (aabb.intersects(lookupBox)) {
				double d1 = projectilePosition.squareDistanceTo(projectilePosition);
				if (d1 < d0) {
					entity = entity1;
					d0 = d1;
				}
			}
		}
		return entity == null ? null : new EntityRayTraceResult(entity);
	}

	private Direction determineHitDirection(AxisAlignedBB entityBox, AxisAlignedBB blockBox) {
		double dx = entityBox.getCenter().x - blockBox.getCenter().x;
		double dy = entityBox.getCenter().y - blockBox.getCenter().y;
		double dz = entityBox.getCenter().z - blockBox.getCenter().z;
		double absDx = Math.abs(dx);
		double absDy = Math.abs(dy);
		double absDz = Math.abs(dz);
		if (absDy > absDx && absDy > absDz) {
			return dy > 0 ? Direction.DOWN : Direction.UP;
		} else if (absDx > absDz) {
			return dx > 0 ? Direction.WEST : Direction.EAST;
		} else {
			return dz > 0 ? Direction.NORTH : Direction.SOUTH;
		}
	}
	</#if>

	<#if hasProcedure(data.onHitsPlayer)>
	@Override public void onCollideWithPlayer(PlayerEntity entity) {
		super.onCollideWithPlayer(entity);
		<@procedureCode data.onHitsPlayer, {
			"x": "this.getPosX()",
			"y": "this.getPosY()",
			"z": "this.getPosZ()",
			"entity": "entity",
			"sourceentity": "this.func_234616_v_()",
			"immediatesourceentity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onHitsEntity)>
	@Override public void onEntityHit(EntityRayTraceResult entityHitResult) {
		super.onEntityHit(entityHitResult);
		<@procedureCode data.onHitsEntity, {
			"x": "this.getPosX()",
			"y": "this.getPosY()",
			"z": "this.getPosZ()",
			"entity": "entityHitResult.getEntity()",
			"sourceentity": "this.func_234616_v_()",
			"immediatesourceentity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	<#if hasProcedure(data.onHitsBlock)>
	@Override public void func_230299_a_(BlockRayTraceResult blockHitResult) {
		super.func_230299_a_(blockHitResult);
		<@procedureCode data.onHitsBlock, {
			"x": "blockHitResult.getPos().getX()",
			"y": "blockHitResult.getPos().getY()",
			"z": "blockHitResult.getPos().getZ()",
			"entity": "this.func_234616_v_()",
			"immediatesourceentity": "this",
			"world": "this.world"
		}/>
	}
	</#if>

	@Override public void tick() {
		super.tick();

		<#if (data.modelWidth > 0.5) || (data.modelHeight > 0.5)>
		if (!this.getNoClip()) {
			this.world.getCollisionShapes(this, this.getBoundingBox()).forEach(collision -> {
				for (AxisAlignedBB blockAABB : collision.toBoundingBoxList()) {
					if (this.getBoundingBox().intersects(blockAABB)) {
						BlockPos blockPos = new BlockPos((int) blockAABB.minX, (int) blockAABB.minY, (int) blockAABB.minZ);
						Vector3d intersectionPoint = new Vector3d((blockAABB.minX + blockAABB.maxX) / 2, (blockAABB.minY + blockAABB.maxY) / 2, (blockAABB.minZ + blockAABB.maxZ) / 2);
						Direction hitDirection = determineHitDirection(this.getBoundingBox(), blockAABB);
						this.func_230299_a_(new BlockRayTraceResult(intersectionPoint, hitDirection, blockPos, false));
					}
				}
			});
		}
		</#if>

		<#if hasProcedure(data.onFlyingTick)>
			<@procedureCode data.onFlyingTick, {
				"x": "this.getPosX()",
				"y": "this.getPosY()",
				"z": "this.getPosZ()",
				"world": "this.world",
				"entity": "this.func_234616_v_()",
				"immediatesourceentity": "this"
			}/>
		</#if>

		if (this.inGround)
			this.remove();
	}

	public static ${name}Entity shoot(World world, LivingEntity entity, Random source) {
		return shoot(world, entity, source, ${data.power}f, ${data.damage}, ${data.knockback});
	}

	public static ${name}Entity shoot(World world, LivingEntity entity, Random source, float pullingPower) {
		return shoot(world, entity, source, pullingPower * ${data.power}f, ${data.damage}, ${data.knockback});
	}

	public static ${name}Entity shoot(World world, LivingEntity entity, Random random, float power, double damage, int knockback) {
		${name}Entity entityarrow = new ${name}Entity(${JavaModName}Entities.${REGISTRYNAME}.get(), entity, world);
		entityarrow.shoot(entity.getLook(1).x, entity.getLook(1).y, entity.getLook(1).z, power * 2, 0);
		entityarrow.setSilent(true);
		entityarrow.setIsCritical(${data.showParticles});
		entityarrow.setDamage(damage);
		entityarrow.setKnockbackStrength(knockback);
		<#if data.igniteFire>
			entityarrow.setFire(100);
		</#if>
		world.addEntity(entityarrow);

		world.playSound(null, entity.getPosX(), entity.getPosY(), entity.getPosZ(), ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.actionSound}")), SoundCategory.PLAYERS, 1, 1f / (random.nextFloat() * 0.5f + 1) + (power / 2));
		return entityarrow;
	}

	public static ${name}Entity shoot(LivingEntity entity, LivingEntity target) {
		${name}Entity entityarrow = new ${name}Entity(${JavaModName}Entities.${REGISTRYNAME}.get(), entity, entity.world);
		double dx = target.getPosX() - entity.getPosX();
		double dy = target.getPosY() + target.getEyeHeight() - 1.1;
		double dz = target.getPosZ() - entity.getPosZ();
		entityarrow.shoot(dx, dy - entityarrow.getPosY() + MathHelper.sqrt(dy * dy + dz * dz) * 0.2F, dz, ${data.power}f * 2, 12.0F);

		entityarrow.setSilent(true);
		entityarrow.setDamage(${data.damage});
		entityarrow.setKnockbackStrength(${data.knockback});
		entityarrow.setIsCritical(${data.showParticles});
		<#if data.igniteFire>
			entityarrow.setFire(100);
		</#if>
		entity.world.addEntity(entityarrow);
		entity.world.playSound(null, entity.getPosX(), entity.getPosY(), entity.getPosZ(), ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${data.actionSound}")), SoundCategory.PLAYERS, 1, 1f / (new Random().nextFloat() * 0.5f + 1));
		return entityarrow;
	}
}
</#compress>
<#-- @formatter:on -->
