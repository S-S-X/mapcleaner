local has_areas_mod = minetest.get_modpath("areas")


function mapcleaner.is_chunk_protected(chunk_pos)
	local min_mapblock_pos, max_mapblock_pos = mapcleaner.get_mapblocks_from_chunk(chunk_pos)

	for x=min_mapblock_pos.x,max_mapblock_pos.x do
		for y=min_mapblock_pos.y,max_mapblock_pos.y do
			for z=min_mapblock_pos.z,max_mapblock_pos.z do
				if mapcleaner.is_mapblock_protected({x=x, y=y, z=z}) then
					return true
				end
			end
		end
	end

	return false
end

-- returns true if the mapblock is protected
function mapcleaner.is_mapblock_protected(mapblock_pos)
	local min, max = mapcleaner.get_blocks_from_mapblock(mapblock_pos)

	if has_areas_mod then
		local areas_map = areas:getAreasIntersectingArea(min, max)
		local area_count = 0
		for _ in pairs(areas_map) do
			area_count = area_count + 1
		end

		if area_count > 0 then
			return true
		end
	end

	-- load area
	minetest.get_voxel_manip(min, max)

	local nodes = minetest.find_nodes_in_area(min, max, {
		"protector:protect",
		"protector:protect2"
	})

	return nodes and #nodes > 0
end