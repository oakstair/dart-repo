// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "vm/il_printer.h"

#include "vm/intermediate_language.h"
#include "vm/os.h"

namespace dart {

DEFINE_FLAG(bool, print_environments, false, "Print SSA environments.");


void BufferFormatter::Print(const char* format, ...) {
  va_list args;
  va_start(args, format);
  VPrint(format, args);
  va_end(args);
}


void BufferFormatter::VPrint(const char* format, va_list args) {
  intptr_t available = size_ - position_;
  if (available <= 0) return;
  intptr_t written =
      OS::VSNPrint(buffer_ + position_, available, format, args);
  if (written >= 0) {
    position_ += (available <= written) ? available : written;
  }
}


void FlowGraphPrinter::PrintBlocks() {
  if (!function_.IsNull()) {
    OS::Print("==== %s\n", function_.ToFullyQualifiedCString());
  }

  for (intptr_t i = 0; i < block_order_.length(); ++i) {
    // Print the block entry.
    PrintInstruction(block_order_[i]);
    Instruction* current = block_order_[i]->successor();
    // And all the successors until an exit, branch, or a block entry.
    while ((current != NULL) && !current->IsBlockEntry()) {
      OS::Print("\n");
      PrintInstruction(current);
      current = current->successor();
    }
    BlockEntryInstr* successor =
        (current == NULL) ? NULL : current->AsBlockEntry();
    if (successor != NULL) {
      OS::Print(" goto %d", successor->block_id());
    }
    OS::Print("\n");
  }
}


void FlowGraphPrinter::PrintInstruction(Instruction* instr) {
  char str[120];
  BufferFormatter f(str, sizeof(str));
  instr->PrintTo(&f);
  if (FLAG_print_environments && (instr->env() != NULL)) {
    instr->env()->PrintTo(&f);
  }
  OS::Print("%s", str);
}


void FlowGraphPrinter::PrintComputation(Computation* comp) {
  char str[120];
  BufferFormatter f(str, sizeof(str));
  comp->PrintTo(&f);
  OS::Print("%s", str);
}


void Computation::PrintTo(BufferFormatter* f) const {
  f->Print("%s(", DebugName());
  PrintOperandsTo(f);
  f->Print(")");
}


void Computation::PrintOperandsTo(BufferFormatter* f) const {
  for (int i = 0; i < InputCount(); ++i) {
    if (i > 0) f->Print(", ");
    if (InputAt(i) != NULL) InputAt(i)->PrintTo(f);
  }
}


void UseVal::PrintTo(BufferFormatter* f) const {
  if (definition()->ssa_temp_index() != -1) {
    f->Print("v%d", definition()->ssa_temp_index());
  } else {
    f->Print("t%d", definition()->temp_index());
  }
}


void ConstantVal::PrintTo(BufferFormatter* f) const {
  f->Print("#%s", value().ToCString());
}


void AssertAssignableComp::PrintOperandsTo(BufferFormatter* f) const {
  value()->PrintTo(f);
  f->Print(", %s, '%s'",
            String::Handle(dst_type().Name()).ToCString(),
            dst_name().ToCString());
  f->Print(" (instantiator:");
  instantiator()->PrintTo(f);
  f->Print(")");
  f->Print(" (instantiator_type_arguments:");
  instantiator_type_arguments()->PrintTo(f);
  f->Print(")");
}


void ClosureCallComp::PrintOperandsTo(BufferFormatter* f) const {
  for (intptr_t i = 0; i < ArgumentCount(); ++i) {
    if (i == 0) f->Print(", ");
    ArgumentAt(i)->PrintTo(f);
  }
}


void InstanceCallComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s", function_name().ToCString());
  for (intptr_t i = 0; i < ArgumentCount(); ++i) {
    f->Print(", ");
    ArgumentAt(i)->PrintTo(f);
  }
}


void StrictCompareComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", Token::Str(kind()));
  left()->PrintTo(f);
  f->Print(", ");
  right()->PrintTo(f);
}


void EqualityCompareComp::PrintOperandsTo(BufferFormatter* f) const {
  left()->PrintTo(f);
  f->Print(" == ");
  right()->PrintTo(f);
}


void StaticCallComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s", String::Handle(function().name()).ToCString());
  for (intptr_t i = 0; i < ArgumentCount(); ++i) {
    f->Print(", ");
    ArgumentAt(i)->PrintTo(f);
  }
}


void LoadLocalComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s lvl:%d", local().name().ToCString(), context_level());
}


void StoreLocalComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", local().name().ToCString());
  value()->PrintTo(f);
  f->Print(", lvl: %d", context_level());
}


void NativeCallComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s", native_name().ToCString());
}


void LoadInstanceFieldComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", String::Handle(field().name()).ToCString());
  instance()->PrintTo(f);
}


void StoreInstanceFieldComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", String::Handle(field().name()).ToCString());
  instance()->PrintTo(f);
  f->Print(", ");
  value()->PrintTo(f);
}


void LoadStaticFieldComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s", String::Handle(field().name()).ToCString());
}


void StoreStaticFieldComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", String::Handle(field().name()).ToCString());
  value()->PrintTo(f);
}


void InstanceOfComp::PrintOperandsTo(BufferFormatter* f) const {
  value()->PrintTo(f);
  f->Print(" %s %s",
            negate_result() ? "ISNOT" : "IS",
            String::Handle(type().Name()).ToCString());
  f->Print(" (instantiator:");
  instantiator()->PrintTo(f);
  f->Print(")");
  f->Print(" (type-arg:");
  instantiator_type_arguments()->PrintTo(f);
  f->Print(")");
}


void RelationalOpComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", Token::Str(kind()));
  left()->PrintTo(f);
  f->Print(", ");
  right()->PrintTo(f);
}


void AllocateObjectComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s", Class::Handle(constructor().owner()).ToCString());
  for (intptr_t i = 0; i < arguments().length(); i++) {
    f->Print(", ");
    arguments()[i]->PrintTo(f);
  }
}


void AllocateObjectWithBoundsCheckComp::PrintOperandsTo(
    BufferFormatter* f) const {
  f->Print("%s", Class::Handle(constructor().owner()).ToCString());
  for (intptr_t i = 0; i < arguments().length(); i++) {
    f->Print(", ");
    arguments()[i]->PrintTo(f);
  }
}


void CreateArrayComp::PrintOperandsTo(BufferFormatter* f) const {
  for (int i = 0; i < ElementCount(); ++i) {
    if (i != 0) f->Print(", ");
    ElementAt(i)->PrintTo(f);
  }
  if (ElementCount() > 0) f->Print(", ");
  element_type()->PrintTo(f);
}


void CreateClosureComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s", function().ToCString());
  f->Print(", ");
  type_arguments()->PrintTo(f);
  f->Print(", ");
  receiver()->PrintTo(f);
}


void LoadVMFieldComp::PrintOperandsTo(BufferFormatter* f) const {
  value()->PrintTo(f);
  f->Print(", %d", offset_in_bytes());
}


void StoreVMFieldComp::PrintOperandsTo(BufferFormatter* f) const {
  dest()->PrintTo(f);
  f->Print(", %d, ", offset_in_bytes());
  value()->PrintTo(f);
}


void InstantiateTypeArgumentsComp::PrintOperandsTo(BufferFormatter* f) const {
  const String& type_args = String::Handle(type_arguments().Name());
  f->Print("%s, ", type_args.ToCString());
  instantiator()->PrintTo(f);
}


void ExtractConstructorTypeArgumentsComp::PrintOperandsTo(
    BufferFormatter* f) const {
  const String& type_args = String::Handle(type_arguments().Name());
  f->Print("%s, ", type_args.ToCString());
  instantiator()->PrintTo(f);
}


void AllocateContextComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%d", num_context_variables());
}


void CatchEntryComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, %s",
           exception_var().name().ToCString(),
           stacktrace_var().name().ToCString());
}


void BinaryOpComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", Token::Str(op_kind()));
  left()->PrintTo(f);
  f->Print(", ");
  right()->PrintTo(f);
}


void UnarySmiOpComp::PrintOperandsTo(BufferFormatter* f) const {
  f->Print("%s, ", Token::Str(op_kind()));
  value()->PrintTo(f);
}


void ToDoubleComp::PrintOperandsTo(BufferFormatter* f) const {
  ASSERT(from() == kDouble || from() == kSmi);
  f->Print("%s ", from() == kDouble ? "double2double" : "smi2double");
  value()->PrintTo(f);
}


void GraphEntryInstr::PrintTo(BufferFormatter* f) const {
  f->Print("%2d: [graph]", block_id());
  if (start_env_ != NULL) {
    for (intptr_t i = 0; i < start_env_->length(); ++i) {
      f->Print("\n  ");
      (*start_env_)[i]->PrintTo(f);
    }
  }
}


void JoinEntryInstr::PrintTo(BufferFormatter* f) const {
  f->Print("%2d: [join]", block_id());
  if (phis_ != NULL) {
    for (intptr_t i = 0; i < phis_->length(); ++i) {
      if ((*phis_)[i] == NULL) continue;
      f->Print("\n");
      (*phis_)[i]->PrintTo(f);
    }
  }
}


void PhiInstr::PrintTo(BufferFormatter* f) const {
  f->Print("    v%d <- phi(", ssa_temp_index());
  for (intptr_t i = 0; i < inputs_.length(); ++i) {
    if (inputs_[i] != NULL) inputs_[i]->PrintTo(f);
    if (i < inputs_.length() - 1) f->Print(",");
  }
  f->Print(")");
}


void TargetEntryInstr::PrintTo(BufferFormatter* f) const {
  f->Print("%2d: [target", block_id());
  if (HasTryIndex()) {
    f->Print(" catch %d]", try_index());
  } else {
    f->Print("]");
  }
}


void DoInstr::PrintTo(BufferFormatter* f) const {
  f->Print("    ");
  computation()->PrintTo(f);
}


void BindInstr::PrintTo(BufferFormatter* f) const {
  if (ssa_temp_index() != -1) {
    f->Print("    v%d <- ", ssa_temp_index());
  } else {
    f->Print("    t%d <- ", temp_index());
  }
  computation()->PrintTo(f);
}


void ReturnInstr::PrintTo(BufferFormatter* f) const {
  f->Print("    %s ", DebugName());
  value()->PrintTo(f);
}


void ThrowInstr::PrintTo(BufferFormatter* f) const {
  f->Print("    %s ", DebugName());
  exception()->PrintTo(f);
}


void ReThrowInstr::PrintTo(BufferFormatter* f) const {
  f->Print("    %s ", DebugName());
  exception()->PrintTo(f);
  f->Print(", ");
  stack_trace()->PrintTo(f);
}


void BranchInstr::PrintTo(BufferFormatter* f) const {
  f->Print("    %s ", DebugName());
  f->Print("if ");
  value()->PrintTo(f);
  if (is_fused_with_comparison()) {
    f->Print(" (fused)");
  }
  if (is_negated()) {
    f->Print(" (negated)");
  }
  f->Print(" goto (%d, %d)",
            true_successor()->block_id(),
            false_successor()->block_id());
}


void ParallelMoveInstr::PrintTo(BufferFormatter* f) const {
  UNIMPLEMENTED();
}


void FlowGraphVisualizer::Print(const char* format, ...) {
  char str[120];
  BufferFormatter f(str, sizeof(str));
  f.Print("%*s", 2 * indent_, "");
  va_list args;
  va_start(args, format);
  f.VPrint(format, args);
  va_end(args);
  (*Dart::flow_graph_writer())(str, strlen(str));
}


void FlowGraphVisualizer::PrintInstruction(Instruction* instr) {
  char str[120];
  BufferFormatter f(str, sizeof(str));
  instr->PrintToVisualizer(&f);
  if (FLAG_print_environments && (instr->env() != NULL)) {
    instr->env()->PrintTo(&f);
  }
  f.Print(" <|@\n");
  (*Dart::flow_graph_writer())(str, strlen(str));
}


void FlowGraphVisualizer::PrintFunction() {
#define BEGIN(name)          \
  Print("begin_%s\n", name); \
  indent_++;
#define END(name)          \
  Print("end_%s\n", name); \
  indent_--;

  {
    BEGIN("compilation");
    const char* name = function_.ToFullyQualifiedCString();
    Print("%s \"%s\"\n", "name", name);
    Print("%s \"%s\"\n", "method", name);
    Print("%s %d\n", "date", 0);  // Required field. Unused.
    END("compilation");
  }

  {
    BEGIN("cfg");
    Print("%s \"%s\"\n", "name", "Flow graph builder");

    for (intptr_t i = 0; i < block_order_.length(); ++i) {
      BEGIN("block");
      BlockEntryInstr* entry = block_order_[i];
      Print("%s \"B%d\"\n", "name", entry->block_id());
      Print("%s %d\n", "from_bci", -1);  // Required field. Unused.
      Print("%s %d\n", "to_bci", -1);  // Required field. Unused.

      Print("predecessors");
      for (intptr_t j = 0; j < entry->PredecessorCount(); ++j) {
        BlockEntryInstr* pred = entry->PredecessorAt(j);
        Print(" \"B%d\"", pred->block_id());
      }
      Print("\n");

      Print("successors");
      Instruction* last = entry->last_instruction();
      for (intptr_t j = 0; j < last->SuccessorCount(); ++j) {
        intptr_t next_id = last->SuccessorAt(j)->block_id();
        Print(" \"B%d\"", next_id);
      }
      Print("\n");

      // TODO(fschneider): Use this for exception handlers.
      Print("xhandlers\n");

      // Can be freely used to mark blocks
      Print("flags\n");

      if (entry->dominator() != NULL) {
        Print("%s \"B%d\"\n", "dominator", entry->dominator()->block_id());
      }

      // TODO(fschneider): Mark blocks with loop nesting level.
      Print("%s %d\n", "loop_depth", 0);

      {
        BEGIN("states");  // Required section.
        {
          BEGIN("locals");  // Required section.
          JoinEntryInstr* join = entry->AsJoinEntry();
          intptr_t num_phis = (join != NULL && join->phi_count())
              ? join->phis()->length()
              : 0;
          Print("%s %d\n", "size", num_phis);
          for (intptr_t j = 0; j < num_phis; ++j) {
            PhiInstr* phi = (*join->phis())[j];
            if (phi != NULL) {
              Print("%d ", j);  // Print variable index.
              char buffer[120];
              BufferFormatter formatter(buffer, sizeof(buffer));
              phi->PrintToVisualizer(&formatter);
              Print("%s\n", buffer);
            }
          }
          END("locals");
        }
        END("states");
      }

      {
        BEGIN("HIR");
        // Print the block entry.
        Print("0 0 ");  // Required fields "bci" and "use". Unused.
        Instruction* current = block_order_[i];
        PrintInstruction(current);
        current = current->successor();
        // And all the successors until an exit, branch, or a block entry.
        while ((current != NULL) && !current->IsBlockEntry()) {
          Print("0 0 ");
          PrintInstruction(current);
          current = current->successor();
        }
        BlockEntryInstr* successor =
            (current == NULL) ? NULL : current->AsBlockEntry();
        if (successor != NULL) {
          Print("0 0 _ Goto B%d <|@\n", successor->block_id());
        }
        END("HIR");
      }
      END("block");
    }
    END("cfg");
  }
#undef BEGIN
#undef END
}


// === Printing instructions in a visualizer-understandable format:
// "result instruction(op1, op2)" where result is a temporary name
// or _ for instruction without result.
void GraphEntryInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ [graph]");
}


void JoinEntryInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ [join]");
}


void PhiInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("v%d [", ssa_temp_index());
  bool has_constant = false;
  for (intptr_t i = 0; i < InputCount(); ++i) {
    if (i > 0) f->Print(" ");
    if (InputAt(i)->IsConstant()) {
      f->Print("const");
      has_constant = true;
    } else {
      InputAt(i)->PrintTo(f);
    }
  }
  f->Print("]");
  // The vizualizer file format does not allow arbitrary strings inside the phi.
  // Print constants as a line-end comment instead.
  if (has_constant) {
    f->Print("\"");
    for (intptr_t i = 0; i < InputCount(); ++i) {
      if (i > 0) f->Print(" ");
      if (InputAt(i)->IsConstant()) {
        InputAt(i)->PrintTo(f);
      }
    }
    f->Print("\"");
  }
}


void TargetEntryInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ [target");
  if (HasTryIndex()) {
    f->Print(" catch %d]", try_index());
  } else {
    f->Print("]");
  }
}


void DoInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ ");
  computation()->PrintTo(f);
}


void BindInstr::PrintToVisualizer(BufferFormatter* f) const {
  if (ssa_temp_index() != -1) {
    f->Print("v%d ", ssa_temp_index());
  } else {
    f->Print("t%d ", temp_index());
  }
  computation()->PrintTo(f);
}


void ReturnInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ %s ", DebugName());
  value()->PrintTo(f);
}


void ThrowInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ %s ", DebugName());
  exception()->PrintTo(f);
}


void ReThrowInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ %s ", DebugName());
  exception()->PrintTo(f);
  f->Print(", ");
  stack_trace()->PrintTo(f);
}


void BranchInstr::PrintToVisualizer(BufferFormatter* f) const {
  f->Print("_ %s ", DebugName());
  f->Print("if ");
  value()->PrintTo(f);
  f->Print(" goto (B%d, B%d)",
            true_successor()->block_id(),
            false_successor()->block_id());
}


void ParallelMoveInstr::PrintToVisualizer(BufferFormatter* f) const {
  UNIMPLEMENTED();
}


void Environment::PrintTo(BufferFormatter* f) const {
  f->Print(" env={ ");
  for (intptr_t i = 0; i < values_.length(); ++i) {
    if (i > 0) f->Print(", ");
    values_[i]->PrintTo(f);
  }
  f->Print(" }");
}

}  // namespace dart
