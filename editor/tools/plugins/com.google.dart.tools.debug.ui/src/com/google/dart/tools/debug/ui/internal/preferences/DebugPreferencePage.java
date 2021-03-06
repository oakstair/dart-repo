/*
 * Copyright (c) 2012, the Dart project authors.
 * 
 * Licensed under the Eclipse Public License v1.0 (the "License"); you may not use this file except
 * in compliance with the License. You may obtain a copy of the License at
 * 
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package com.google.dart.tools.debug.ui.internal.preferences;

import com.google.dart.tools.debug.core.DartDebugCorePlugin;

import org.eclipse.jface.layout.GridDataFactory;
import org.eclipse.jface.layout.GridLayoutFactory;
import org.eclipse.jface.preference.PreferencePage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Group;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPreferencePage;

/**
 * The preference page for Dart debugging.
 */
public class DebugPreferencePage extends PreferencePage implements IWorkbenchPreferencePage {

  public static final String PAGE_ID = "com.google.dart.tools.debug.debugPreferencePage"; //$NON-NLS-1$

  private Button exceptionsCheckbox;

  /**
   * Create a new preference page.
   */
  public DebugPreferencePage() {

  }

  @Override
  public void init(IWorkbench workbench) {
    noDefaultAndApplyButton();
  }

  @Override
  public boolean performOk() {
    DartDebugCorePlugin.getPlugin().setBreakOnExceptions(exceptionsCheckbox.getSelection());

    return true;
  }

  @Override
  protected Control createContents(Composite parent) {
    Composite composite = new Composite(parent, SWT.NONE);
    GridDataFactory.fillDefaults().grab(true, false).indent(0, 10).align(SWT.FILL, SWT.BEGINNING).applyTo(
        composite);
    GridLayoutFactory.fillDefaults().spacing(0, 8).margins(0, 10).applyTo(composite);

    createDebuggerConfig(composite);

    return composite;
  }

  private void createDebuggerConfig(Composite composite) {
    Group group = new Group(composite, SWT.NONE);
    group.setText("Debugging");
    GridDataFactory.fillDefaults().grab(true, false).align(SWT.FILL, SWT.BEGINNING).applyTo(group);
    GridLayoutFactory.fillDefaults().numColumns(1).margins(8, 8).applyTo(group);

    exceptionsCheckbox = new Button(group, SWT.CHECK);
    exceptionsCheckbox.setText("Break on uncaught exceptions");
    exceptionsCheckbox.setSelection(DartDebugCorePlugin.getPlugin().getBreakOnExceptions());
  }

}
