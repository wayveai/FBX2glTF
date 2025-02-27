/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "PrimitiveData.hpp"

#include "AccessorData.hpp"
#include "BufferViewData.hpp"
#include "MaterialData.hpp"

PrimitiveData::PrimitiveData(const AccessorData& indices, const MaterialData& material)
    : indices(indices.ix),
      material(material.ix),
      mode(TRIANGLES) {}

void PrimitiveData::AddAttrib(std::string name, const AccessorData& accessor) {
  attributes[name] = accessor.ix;
}

void PrimitiveData::AddTarget(
    const AccessorData* positions,
    const AccessorData* normals,
    const AccessorData* tangents) {
  targetAccessors.push_back(std::make_tuple(
      positions->ix,
      normals != nullptr ? normals->ix : -1,
      tangents != nullptr ? tangents->ix : -1));
  targetNames.push_back(positions->name);
}

void to_json(json& j, const PrimitiveData& d) {
  j = {{"material", d.material}, {"mode", d.mode}, {"attributes", d.attributes}};
  if (d.indices >= 0) {
    j["indices"] = d.indices;
  }
  if (!d.targetAccessors.empty()) {
    json targets{};
    int pIx, nIx, tIx;
    for (auto accessor : d.targetAccessors) {
      std::tie(pIx, nIx, tIx) = accessor;
      json target{};
      if (pIx >= 0) {
        target["POSITION"] = pIx;
      }
      if (nIx >= 0) {
        target["NORMAL"] = nIx;
      }
      if (tIx >= 0) {
        target["TANGENT"] = tIx;
      }
      targets.push_back(target);
    }
    j["targets"] = targets;
  }
}
