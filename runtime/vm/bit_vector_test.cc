// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "platform/assert.h"
#include "vm/bit_vector.h"
#include "vm/unit_test.h"

namespace dart {

TEST_CASE(BitVector) {
  { BitVector* v = new BitVector(15);
    v->Add(1);
    EXPECT_EQ(true, v->Contains(1));
    EXPECT_EQ(false, v->Contains(0));
    { BitVector::Iterator iter(v);
      EXPECT_EQ(1, iter.Current());
      iter.Advance();
      EXPECT(iter.Done());
    }
    v->Add(0);
    v->Add(1);
    EXPECT_EQ(true, v->Contains(0));
    EXPECT_EQ(true, v->Contains(1));
    { BitVector::Iterator iter(v);
      EXPECT_EQ(0, iter.Current());
      iter.Advance();
      EXPECT_EQ(1, iter.Current());
      iter.Advance();
      EXPECT(iter.Done());
    }
  }

  { BitVector* v = new BitVector(128);
    v->Add(49);
    v->Add(62);
    v->Add(63);
    v->Add(65);
    EXPECT_EQ(true, v->Contains(49));
    EXPECT_EQ(true, v->Contains(62));
    EXPECT_EQ(true, v->Contains(63));
    EXPECT_EQ(true, v->Contains(65));
    EXPECT_EQ(false, v->Contains(64));
    BitVector::Iterator iter(v);
    EXPECT_EQ(49, iter.Current());
    iter.Advance();
    EXPECT_EQ(62, iter.Current());
    iter.Advance();
    EXPECT_EQ(63, iter.Current());
    iter.Advance();
    EXPECT_EQ(65, iter.Current());
    iter.Advance();
    EXPECT(iter.Done());
  }

  { BitVector* a = new BitVector(128);
    BitVector* b = new BitVector(128);
    BitVector* c = new BitVector(128);
    b->Add(0);
    b->Add(32);
    b->Add(64);
    a->AddAll(b);
    EXPECT_EQ(true, a->Contains(0));
    EXPECT_EQ(true, a->Contains(32));
    EXPECT_EQ(true, a->Contains(64));
    EXPECT_EQ(false, a->Contains(96));
    EXPECT_EQ(false, a->Contains(127));
    b->Add(96);
    b->Add(127);
    c->Add(127);
    a->KillAndAdd(c, b);
    EXPECT_EQ(true, a->Contains(0));
    EXPECT_EQ(true, a->Contains(32));
    EXPECT_EQ(true, a->Contains(64));
    EXPECT_EQ(true, a->Contains(96));
    EXPECT_EQ(false, a->Contains(127));
  }
}

}  // namespace dart
