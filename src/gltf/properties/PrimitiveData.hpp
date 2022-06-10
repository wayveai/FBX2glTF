/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include "gltf/Raw2Gltf.hpp"

struct PrimitiveData {
  enum MeshMode {
    POINTS = 0,
    LINES,
    LINE_LOOP,
    LINE_STRIP,
    TRIANGLES,
    TRIANGLE_STRIP,
    TRIANGLE_FAN
  };

  PrimitiveData(const AccessorData& indices, const MaterialData& material);

  void AddAttrib(std::string name, const AccessorData& accessor);

  void AddTarget(
      const AccessorData* positions,
      const AccessorData* normals,
      const AccessorData* tangents);

  const int indices;
  const unsigned int material;
  const MeshMode mode;

  std::vector<std::tuple<int, int, int>> targetAccessors{};
  std::vector<std::string> targetNames{};

  std::map<std::string, int> attributes;
};

void to_json(json& j, const PrimitiveData& d);
