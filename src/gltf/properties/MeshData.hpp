/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <string>

#include "gltf/Raw2Gltf.hpp"

#include "PrimitiveData.hpp"

struct MeshData : Holdable {
  MeshData(const std::string& name, const std::vector<float>& weights);

  void AddPrimitive(std::shared_ptr<PrimitiveData> primitive) {
    primitives.push_back(std::move(primitive));
  }

  json serialize() const override;

  const std::string name;
  const std::vector<float> weights;
  std::vector<std::shared_ptr<PrimitiveData>> primitives;
};
