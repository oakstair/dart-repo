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

package com.google.dart.tools.debug.core.server;

/**
 * A utility class for the VM debugger.
 */
public class VmUtils {
  private static final String VM_FORMAT = "file:///";
  private static final String ECLIPSE_FORMAT = "file:/";

  /**
   * Convert the given URL from Eclipse format (file:/) to VM format (file:///).
   */
  public static String eclipseUrlToVm(String url) {
    // file:/ --> file:///

    if (url == null) {
      return null;
    }

    if (url.startsWith(ECLIPSE_FORMAT)) {
      if (!url.startsWith(ECLIPSE_FORMAT + "/")) {
        url = VM_FORMAT + url.substring(ECLIPSE_FORMAT.length());
      }
    }

    return url;
  }

  /**
   * Convert the given URL from VM format (file:///) to Eclipse format (file:/).
   */
  public static String vmUrlToEclipse(String url) {
    // file:/// --> file:/

    if (url == null) {
      return null;
    }

    if (url.startsWith(VM_FORMAT)) {
      url = ECLIPSE_FORMAT + url.substring(VM_FORMAT.length());
    }

    return url;
  }

}
