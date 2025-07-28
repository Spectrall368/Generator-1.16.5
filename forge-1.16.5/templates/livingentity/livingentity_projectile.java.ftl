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
package ${package}.entity;

@OnlyIn(value = Dist.CLIENT, _interface = IRendersAsItem.class) public class ${name}EntityProjectile extends AbstractArrowEntity implements IRendersAsItem {

	public ${name}EntityProjectile(FMLPlayMessages.SpawnEntity packet, World world) {
		super(${JavaModName}Entities.${REGISTRYNAME}_PROJECTILE.get(), world);
	}

	public ${name}EntityProjectile(EntityType<? extends ${name}EntityProjectile> type, World world) {
		super(type, world);
	}

	public ${name}EntityProjectile(EntityType<? extends ${name}EntityProjectile> type, double x, double y, double z, World world) {
		super(type, x, y, z, world);
	}

	public ${name}EntityProjectile(EntityType<? extends ${name}EntityProjectile> type, LivingEntity entity, World world) {
		super(type, entity, world);
	}

	@Override public IPacket<?> createSpawnPacket() {
		return NetworkHooks.getEntitySpawningPacket(this);
	}

	@Override protected void arrowHit(LivingEntity livingEntity) {
		super.arrowHit(livingEntity);
		livingEntity.setArrowCountInEntity(livingEntity.getArrowCountInEntity() - 1);
	}

	@Override @OnlyIn(Dist.CLIENT) public ItemStack getItem() {
		return ${mappedMCItemToItemStackCode(data.rangedAttackItem, 1)};
	}

	@Override protected ItemStack getArrowStack() {
		return ${mappedMCItemToItemStackCode(data.rangedAttackItem, 1)};
	}
}
<#-- @formatter:on -->
