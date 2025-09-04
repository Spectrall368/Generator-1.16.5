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
package ${package}.world.structures.configurations;

public class StructureConfiguration implements IFeatureConfig {
    private final int maxDepth;
    private final StructureConfiguration.Height startHeight;
    private final Optional<Heightmap.Type> projectStartToHeightmap;
    private final int maxDistanceFromCenter;

    public StructureConfiguration(int maxDepth, StructureConfiguration.Height startHeight,
                                Optional<Heightmap.Type> projectStartToHeightmap, int maxDistanceFromCenter) {
        this.maxDepth = maxDepth;
        this.startHeight = startHeight;
        this.projectStartToHeightmap = projectStartToHeightmap;
        this.maxDistanceFromCenter = maxDistanceFromCenter;
    }

    public int maxDepth() {
        return maxDepth;
    }

    public StructureConfiguration.Height startHeight() {
        return startHeight;
    }

    public Optional<Heightmap.Type> projectStartToHeightmap() {
        return projectStartToHeightmap;
    }

    public int maxDistanceFromCenter() {
        return maxDistanceFromCenter;
    }

    public static final Codec<StructureConfiguration> CODEC = RecordCodecBuilder.create(builder -> {
        return builder.group(
            Codec.intRange(0, 7).fieldOf("size").forGetter(config -> {
                return config.maxDepth();
            }),
            StructureConfiguration.Height.CODEC.fieldOf("start_height").forGetter(config -> {
                return config.startHeight();
            }),
            Heightmap.Type.CODEC.optionalFieldOf("project_start_to_heightmap").forGetter(config -> {
                return config.projectStartToHeightmap();
            }),
            Codec.intRange(1, 128).fieldOf("max_distance_from_center").forGetter(config -> {
                return config.maxDistanceFromCenter();
            })
        ).apply(builder, StructureConfiguration::new);
    });

    public static class Height {
        protected final int min;
        protected final int max;

        protected Height(int min, int max) {
            this.min = min;
            this.max = max;
        }

       public static final Codec<Height> CODEC = RecordCodecBuilder.create(instance -> instance.group(
                Codec.INT.fieldOf("min_inclusive").forGetter(height -> height.min),
                Codec.INT.fieldOf("max_inclusive").forGetter(height -> height.max)
        ).apply(instance, Height::new));

        public int sample(Random random) {
            return 0;
        }
    }

    public static class UniformHeight extends Height {
        public static UniformHeight of(int min, int max) {
            return new UniformHeight(min, max);
        }

        private UniformHeight(int min, int max) {
            super(min, max);
        }

        public int sample(Random random) {
            if (min > max) {
                return min;
            } else {
                return random.nextInt(max - min + 1) + min;
            }
        }
    }

    public static class BiasedToBottomHeight extends Height {
        public static BiasedToBottomHeight of(int min, int max) {
            return new BiasedToBottomHeight(min, max);
        }

        private BiasedToBottomHeight(int min, int max) {
            super(min, max);
        }

        public int sample(Random random) {
            if (max - min <= 0) {
                return min;
            } else {
                int random1 = random.nextInt(max - min);
                return random.nextInt(random1 + 1) + min;
            }
        }
    }

    public static class VeryBiasedToBottomHeight extends Height {
        public static VeryBiasedToBottomHeight of(int min, int max) {
            return new VeryBiasedToBottomHeight(min, max);
        }

        private VeryBiasedToBottomHeight(int min, int max) {
            super(min, max);
        }

        public int sample(Random random) {
            if (max - min <= 0) {
                return min;
            } else {
                int random1 = MathHelper.nextInt(random, min + 1, max);
                int random2 = MathHelper.nextInt(random, min, random1 - 1);
                return MathHelper.nextInt(random, min, random2);
            }
        }
    }

    public static class TrapezoidHeight extends Height {
        public static TrapezoidHeight of(int min, int max) {
            return new TrapezoidHeight(min, max);
        }

        private TrapezoidHeight(int min, int max) {
            super(min, max);
        }

        public int sample(Random random) {
            if (min > max) {
                return min;
            } else {
                int mid = max - min;
                if (0 >= mid) {
                    return random.nextInt(max - min + 1) + min;
                } else {
                    int random1 = mid / 2;
                    int random2 = mid - random1;
                    return min + (random.nextInt(random2 + 1)) + (random.nextInt(random1 + 1));
                }
            }
        }
    }

    public static class ConstantHeight extends Height {
        public static ConstantHeight of(int height) {
            return new ConstantHeight(height);
        }

        private ConstantHeight(int height) {
            super(height, height);
        }

        public int sample(Random random) {
            return min;
        }
    }
}
<#-- @formatter:on -->