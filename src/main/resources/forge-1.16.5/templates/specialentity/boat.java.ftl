<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
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
package ${package}.entity;

import net.minecraft.network.datasync.DataParameter;

public class ${JavaModName}Boat extends BoatEntity {
	private static final DataParameter<Integer> DATA_ID_TYPE = EntityDataManager.createKey(${JavaModName}Boat.class, DataSerializers.VARINT);

	public ${JavaModName}Boat(FMLPlayMessages.SpawnEntity packet, World world) {
		this(${JavaModName}Entities.${JavaModName?upper_case}_BOAT.get(), world);
	}

	public ${JavaModName}Boat(EntityType<? extends BoatEntity> entityType, World level) {
		super(entityType, level);
	}

    public ${JavaModName}Boat(World level, double x, double y, double z) {
        this(${JavaModName}Entities.${JavaModName?upper_case}_BOAT.get(), level);
        this.setPosition(x, y, z);
        this.setMotion(Vector3d.ZERO);
        this.prevPosX = x;
        this.prevPosY = y;
        this.prevPosZ = z;
    }

	@Override public IPacket<?> createSpawnPacket() {
		return NetworkHooks.getEntitySpawningPacket(this);
	}

	@Override public ITextComponent getDisplayName() {
		return new TranslationTextComponent("entity.minecraft.boat");
	}

	@Override public Item getItemBoat() {
		switch (getModType()) {
		<#list specialentities as entity>
		    case ${entity.getModElement().getRegistryNameUpper()}:
		        return ${JavaModName}Items.${entity.getModElement().getRegistryNameUpper()}.get();
		</#list>
		    default:
		        return Items.AIR;
		}
	}

	@Override protected void registerData() {
		super.registerData();
		this.dataManager.register(DATA_ID_TYPE, Type.${specialentities[0].getModElement().getRegistryNameUpper()}.ordinal());
	}

	@Override protected void writeAdditional(CompoundNBT compound) {
		compound.putString("Type", getModType().getName());
	}

	@Override protected void readAdditional(CompoundNBT compound) {
		if (compound.contains("Type", 8)) {
			setBoatType(Type.getTypeFromString(compound.getString("Type")));
		}
	}

	public void setBoatType(Type variant) {
		this.dataManager.set(DATA_ID_TYPE, variant.ordinal());
	}

	public Type getModType() {
		return Type.byId(this.dataManager.get(DATA_ID_TYPE));
	}

	public static enum Type {
        <@javacompress>
            <#list specialentities as entity>
                ${entity.getModElement().getRegistryNameUpper()}(Blocks.OAK_PLANKS, "${entity.getModElement().getRegistryName()}")<#sep>,
            </#list>;
        </@javacompress>

        private final String name;
        private final Block planks;

        private Type(Block block, String name) {
            this.name = name;
            this.planks = block;
        }

        public String getName() {
            return name;
        }

        public Block getPlanks() {
            return planks;
        }

        public String toString() {
            return name;
        }

        public static ${JavaModName}Boat.Type byId(int id) {
            Type[] type = values();
            if (id < 0 || id >= type.length)
                id = 0;

            return type[id];
        }

        public static ${JavaModName}Boat.Type getTypeFromString(String name) {
            Type[] type = values();

            for(int i = 0; i < type.length; ++i) {
                if (type[i].getName().equals(name))
                    return type[i];
            }

            return type[0];
        }
	}
}
<#-- @formatter:on -->