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
package com.google.dart.tools.core;

import com.google.dart.tools.core.analysis.index.AnalysisIndexManager;
import com.google.dart.tools.core.frog.FrogManager;
import com.google.dart.tools.core.internal.MessageConsoleImpl;
import com.google.dart.tools.core.internal.builder.RootArtifactProvider;
import com.google.dart.tools.core.internal.directoryset.DirectorySetManager;
import com.google.dart.tools.core.internal.model.DartModelImpl;
import com.google.dart.tools.core.internal.model.DartModelManager;
import com.google.dart.tools.core.internal.operation.BatchOperation;
import com.google.dart.tools.core.internal.util.Extensions;
import com.google.dart.tools.core.internal.util.MementoTokenizer;
import com.google.dart.tools.core.internal.util.Util;
import com.google.dart.tools.core.internal.workingcopy.DefaultWorkingCopyOwner;
import com.google.dart.tools.core.model.DartElement;
import com.google.dart.tools.core.model.DartLibrary;
import com.google.dart.tools.core.model.DartModel;
import com.google.dart.tools.core.model.DartModelException;
import com.google.dart.tools.core.model.DartProject;
import com.google.dart.tools.core.model.DartSdk;
import com.google.dart.tools.core.model.ElementChangedEvent;
import com.google.dart.tools.core.model.ElementChangedListener;
import com.google.dart.tools.core.utilities.general.StringUtilities;
import com.google.dart.tools.core.utilities.performance.PerformanceManager;
import com.google.dart.tools.core.workingcopy.WorkingCopyOwner;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IFolder;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspace;
import org.eclipse.core.resources.IWorkspaceRoot;
import org.eclipse.core.resources.IWorkspaceRunnable;
import org.eclipse.core.resources.ResourcesPlugin;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.core.runtime.Platform;
import org.eclipse.core.runtime.Plugin;
import org.eclipse.core.runtime.Status;
import org.eclipse.core.runtime.content.IContentType;
import org.eclipse.core.runtime.jobs.ISchedulingRule;
import org.eclipse.core.runtime.preferences.IEclipsePreferences;
import org.eclipse.core.runtime.preferences.InstanceScope;
import org.osgi.framework.BundleContext;
import org.osgi.framework.Version;

import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Map;

/**
 * The class <code>DartCore</code> is used to access the elements modeling projects that have a Dart
 * nature.
 */
public class DartCore extends Plugin {
  /**
   * The unique instance of this class.
   */
  private static DartCore PLUG_IN;

  /**
   * The id of the plug-in that defines the Dart model.
   */
  public static final String PLUGIN_ID = DartCore.class.getPackage().getName();

  /**
   * The id of the project nature used for Dart projects.
   */
  public static final String DART_PROJECT_NATURE = PLUGIN_ID + ".dartNature";

  /**
   * The id of the builder used for Dart projects.
   */
  public static final String DART_BUILDER_ID = PLUGIN_ID + ".dartBuilder";

  /**
   * The id of the content type used to represent Dart compilation units.
   */
  public static final String DART_SOURCE_CONTENT_TYPE = PLUGIN_ID + ".dartSourceFile";

  /**
   * Eclipse problem marker type used to display Dart compilation errors
   */
  public static final String DART_PROBLEM_MARKER_TYPE = PLUGIN_ID + ".problem";

  /**
   * Extension for single unit compiled into JavaScript.
   */
  public static final String EXTENSION_JS = "js";

  /**
   * Preference for the packages root directory
   */
  public static final String PACKAGE_ROOT_DIR_PREFERENCE = "package root";

  /**
   * Preference to control if "not a member" warnings should be suppressed for inferred types.
   */
  public static final String SUPPRESS_NO_MEMBER_FOR_INFERRED_TYPES = "suppressNoMemberWarningForInferredTypes";

  /**
   * Cached extensions for CSS files.
   */
  private static final String[] CSS_FILE_EXTENSIONS = {"css"};

  /**
   * Cached extensions for HTML files.
   */
  private static final String[] HTML_FILE_EXTENSIONS = {"html", "htm"};

  /**
   * Cached extensions for JS files.
   */
  private static final String[] JS_FILE_EXTENSIONS = {"js"};

  /**
   * Cached extensions for TXT files.
   */
  private static final String[] TXT_FILE_EXTENSIONS = {"txt"};

  /**
   * Cached extensions for files that are generated by the dartc compiler.
   */
  private static final String[] DART_GENERATED_FILE_EXTENSIONS = {"api", "deps", "js", "map"};

  /**
   * Cached extensions for image files.
   */
  private static final String[] IMAGE_FILE_EXTENSIONS = {
      "bmp", "gif", "jpeg", "jpg", "png", "raw", "thm", "tif", "tiff"};

  /**
   * The shared message console instance.
   */
  private static final MessageConsole CONSOLE = new MessageConsoleImpl();

  /**
   * Configures the given marker attribute map for the given Dart element. Used for markers, which
   * denote a Dart element rather than a resource.
   * 
   * @param attributes the mutable marker attribute map
   * @param element the Dart element for which the marker needs to be configured
   */
  public static void addDartElementMarkerAttributes(Map<String, String> attributes,
      DartElement element) {
    // if (element instanceof IMember)
    // element = ((IMember) element).getClassFile();
    // if (attributes != null && element != null) {
    // attributes.put(ATT_HANDLE_ID, element.getHandleIdentifier());
    // }
    notYetImplemented();
  }

  /**
   * Add the given listener to the list of objects that are listening for changes to Dart elements.
   * Has no effect if an identical listener is already registered.
   * <p>
   * This listener will only be notified during the POST_CHANGE resource change notification and any
   * reconcile operation (POST_RECONCILE). For finer control of the notification, use
   * {@link #addElementChangedListener(IElementChangedListener,int)}, which allows to specify a
   * different eventMask.
   * 
   * @param listener the listener being added
   */
  public static void addElementChangedListener(ElementChangedListener listener) {
    addElementChangedListener(listener, ElementChangedEvent.POST_CHANGE
        | ElementChangedEvent.POST_RECONCILE);
  }

  /**
   * Add the given listener to the list of objects that are listening for changes to Dart elements.
   * Has no effect if an identical listener is already registered. After completion of this method,
   * the given listener will be registered for exactly the specified events. If they were previously
   * registered for other events, they will be de-registered.
   * <p>
   * Once registered, a listener starts receiving notification of changes to Dart elements in the
   * model. The listener continues to receive notifications until it is replaced or removed.
   * </p>
   * <p>
   * Listeners can listen for several types of event as defined in <code>ElementChangeEvent</code>.
   * Clients are free to register for any number of event types, however if they register for more
   * than one, it is their responsibility to ensure they correctly handle the case where the same
   * Dart element change shows up in multiple notifications. Clients are guaranteed to receive only
   * the events for which they are registered.
   * </p>
   * 
   * @param listener the listener being added
   * @param eventMask the bit-wise OR of all event types of interest to the listener
   */
  public static void addElementChangedListener(ElementChangedListener listener, int eventMask) {
    DartModelManager.getInstance().addElementChangedListener(listener, eventMask);
  }

  /**
   * Return the Dart element corresponding to the given file, or <code>null</code> if the given file
   * is not associated with any Dart element.
   * 
   * @param file the file corresponding to the Dart element
   * @return the Dart element corresponding to the given file
   */
  public static DartElement create(IFile file) {
    return DartModelManager.getInstance().create(file);
  }

  /**
   * Return the Dart element corresponding to the given folder, or <code>null</code> if the given
   * file is not associated with any Dart element.
   * 
   * @param folder the folder corresponding to the Dart element
   * @return the Dart element corresponding to the given folder
   */
  public static DartElement create(IFolder folder) {
    return DartModelManager.getInstance().create(folder);
  }

  /**
   * Return the Dart project corresponding to the given project. Note that no check is made to
   * ensure that the project has the Dart nature.
   * 
   * @param project the resource corresponding to the Dart project
   * @return the Dart project corresponding to the given project
   */
  public static DartProject create(IProject project) {
    return DartModelManager.getInstance().create(project);
  }

  /**
   * Return the Dart element corresponding to the given resource, or <code>null</code> if the given
   * resource is not associated with any Dart element.
   * 
   * @param resource the resource corresponding to the Dart element
   * @return the Dart element corresponding to the given resource
   */
  public static DartElement create(IResource resource) {
    return DartModelManager.getInstance().create(resource);
  }

  /**
   * Return the Dart model corresponding to the given workspace root.
   * 
   * @param project the workspace root corresponding to the model
   * @return the Dart model corresponding to the given workspace root
   */
  public static DartModel create(IWorkspaceRoot workspaceRoot) {
    if (workspaceRoot == null) {
      return null;
    }
    return DartModelManager.getInstance().getDartModel();
  }

  /**
   * Return the element represented by the given identifier, or <code>null</code> if the identifier
   * does not represent any element.
   * 
   * @param identifier the identifier used to identify a specific element in the Dart element
   *          structure
   * @return the element represented by the given identifier
   */
  public static DartElement create(String identifier) {
    return create(identifier, DefaultWorkingCopyOwner.getInstance());
  }

  /**
   * Returns the Dart model element corresponding to the given handle identifier generated by
   * <code>DartElement.getHandleIdentifier()</code>, or <code>null</code> if unable to create the
   * associated element. If the returned Dart element is a <code>CompilationUnit</code> or an
   * element inside a compilation unit, the compilation unit's owner is the given owner if such a
   * working copy exists, otherwise the compilation unit is a primary compilation unit.
   * 
   * @param identifier the given handle identifier
   * @param owner the owner of the returned compilation unit, ignored if the returned element is not
   *          a compilation unit, or an element inside a compilation unit
   * @return the Dart element corresponding to the handle identifier
   */
  public static DartElement create(String identifier, WorkingCopyOwner owner) {
    if (identifier == null) {
      return null;
    }
    if (owner == null) {
      owner = DefaultWorkingCopyOwner.getInstance();
    }
    MementoTokenizer memento = new MementoTokenizer(identifier);
    DartModelImpl model = DartModelManager.getInstance().getDartModel();
    return model.getHandleFromMemento(memento, owner);
  }

  /**
   * Given some directory {@link File}, return the {@link DartLibrary} in that directory, if there
   * is such a Dart library that is also already loaded in the Dart Editor workspace. Otherwise,
   * return <code>null</code>.
   * 
   * @see DartModelManager#findLibraryInDirectory
   * @param directory the file defining the library to be opened
   * @return the library found in the passed directory
   * @throws DartModelException if the library exists but could not be opened for some reason
   */
  public static DartLibrary findLibraryInDirectory(File directory) throws DartModelException {
    return DartModelManager.getInstance().findLibraryInDirectory(directory);
  }

  /**
   * Returns the SVN revision number as a String.
   */
  public static String getBuildId() {
    return "@REVISION@";
  }

  /**
   * Return a unique token that can be used to determine whether cached data that changes only when
   * the version of the editor changes is still valid.
   * 
   * @return a token used to determine the validity of cached data
   */
  public static String getBuildIdOrDate() {
    String buildIdOrDate = getBuildId();
    if (buildIdOrDate.startsWith("@")) {
      buildIdOrDate = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
    }
    return buildIdOrDate;
  }

  /**
   * Returns the shared message console. Unlike the log ({@link DartCore#getLog()}), the console is
   * intended for communication with the end-user.
   * 
   * @return the message console
   */
  public static MessageConsole getConsole() {
    return CONSOLE;
  }

  /**
   * Return the list of known Dart-like file extensions. Dart-like extensions are defined in the
   * {@link Platform.getContentManager() content type manager} for the
   * {@link #DART_SOURCE_CONTENT_TYPE}. Note that a Dart-like extension does not include the leading
   * dot, and that the "dart" extension is always defined as a Dart-like extension.
   * 
   * @return the list of known Dart-like file extensions
   */
  public static String[] getDartLikeExtensions() {
    IContentType dartContentType = Platform.getContentTypeManager().getContentType(
        DART_SOURCE_CONTENT_TYPE);
    HashSet<String> extensionSet = new HashSet<String>();
    for (IContentType contentType : Platform.getContentTypeManager().getAllContentTypes()) {
      if (contentType.isKindOf(dartContentType)) {
        for (String extension : contentType.getFileSpecs(IContentType.FILE_EXTENSION_SPEC)) {
          extensionSet.add(extension);
        }
      }
    }
    extensionSet.remove(Extensions.DART);
    ArrayList<String> extensionList = new ArrayList<String>(extensionSet);
    extensionList.add(0, Extensions.DART);
    return extensionList.toArray(new String[extensionList.size()]);
  }

  /**
   * Return a table of all known configurable options with their default values. These options allow
   * to configure the behavior of the underlying components. The client may safely use the result as
   * a template that they can modify and then pass to {@link #setOptions()}</code>.
   * <p>
   * Helper constants have been defined on DartPreferenceConstants for each of the option IDs
   * (categorized in Code assist option ID, Compiler option ID and Core option ID) and some of their
   * acceptable values (categorized in Option value). Some options accept open value sets beyond the
   * documented constant values.
   * <p>
   * Note: each release may add new options.
   * 
   * @return a table of all known configurable options with their default values
   */
  public static Hashtable<String, String> getDefaultOptions() {
    return DartModelManager.getInstance().getDefaultOptions();
  }

  /**
   * Return the static {@link DirectorySetManager} instance.
   */
  public static DirectorySetManager getDirectorySetManager() {
    return DirectorySetManager.getInstance();
  }

  /**
   * Return the workspace root default charset encoding.
   * 
   * @return the name of the default charset encoding for the workspace root
   */
  public static String getEncoding() {
    try {
      return ResourcesPlugin.getWorkspace().getRoot().getDefaultCharset();
    } catch (IllegalStateException exception) {
      // happen when there's no workspace (see bug
      // https://bugs.eclipse.org/bugs/show_bug.cgi?id=216817)
      // or when it is shutting down (see bug
      // https://bugs.eclipse.org/bugs/show_bug.cgi?id=60687)
      return System.getProperty("file.encoding"); //$NON-NLS-1$
    } catch (CoreException exception) {
      // fails silently and return plugin global encoding if core exception
      // occurs
    }
    return ResourcesPlugin.getEncoding();
  }

  /**
   * Utility method for returning one option value only. Equivalent to
   * <code>DartCore.getOptions().get(optionName)</code> Note that it may answer <code>null</code> if
   * this option does not exist.
   * <p>
   * Helper constants have been defined on DartPreferenceConstants for each of the option IDs
   * (categorized in Code assist option ID, Compiler option ID and Core option ID) and some of their
   * acceptable values (categorized in Option value). Some options accept open value sets beyond the
   * documented constant values.
   * <p>
   * Note: each release may add new options.
   * 
   * @param optionName the name of the option whose value is to be returned
   * @return the value of a given option
   */
  public static String getOption(String optionName) {
    return DartModelManager.getInstance().getOption(optionName);
  }

  /**
   * Return the table of the current options. Initially, all options have their default values, and
   * this method returns a table that includes all known options.
   * <p>
   * Helper constants have been defined on DartPreferenceConstants for each of the option IDs
   * (categorized in Code assist option ID, Compiler option ID and Core option ID) and some of their
   * acceptable values (categorized in Option value). Some options accept open value sets beyond the
   * documented constant values.
   * <p>
   * Note: each release may add new options.
   * <p>
   * Returns a default set of options even if the platform is not running.
   * </p>
   * 
   * @return table of current settings of all options (key type: <code>String</code>; value type:
   *         <code>String</code>)
   */
  public static HashMap<String, String> getOptions() {
    return DartModelManager.getInstance().getOptions();
  }

  /**
   * Return the unique instance of this class.
   * 
   * @return the unique instance of this class
   */
  public static DartCore getPlugin() {
    return PLUG_IN;
  }

  /**
   * @return the version text for this plugin (i.e. 1.1.0)
   */
  public static String getVersion() {
    Version version = getPlugin().getBundle().getVersion();

    return version.getMajor() + "." + version.getMinor() + "." + version.getMicro();
  }

  public static boolean is32Bit() {
    return Platform.getOSArch().indexOf("64") == -1;
  }

  /**
   * Return <code>true</code> if the given resource should be analyzed. All resources are to be
   * analyzed unless they have been excluded.
   * 
   * @param resource the resource being tested
   * @return <code>true</code> if the given resource should be analyzed
   */
  public static boolean isAnalyzed(IResource resource) {
    return DartModelManager.getInstance().isAnalyzed(resource);
  }

  /**
   * Return <code>true</code> if the given file name's extension is an CSS-like extension.
   * 
   * @param fileName the file name being tested
   * @return <code>true</code> if the given file name's extension is an CSS-like extension
   */
  public static boolean isCSSLikeFileName(String fileName) {
    return isLikeFileName(fileName, CSS_FILE_EXTENSIONS);
  }

  /**
   * Return <code>true</code> if the given file name's extension is a generated Dart like extension.
   * 
   * @return <code>true</code> if the given file name's extension is a generated Dart like extension
   */
  public static boolean isDartGeneratedFile(String fileName) {
    return isLikeFileName(fileName, DART_GENERATED_FILE_EXTENSIONS);
  }

  /**
   * Return <code>true</code> if the given file name's extension is a Dart-like extension.
   * 
   * @param fileName the file name being tested
   * @return <code>true</code> if the given file name's extension is a Dart-like extension
   * @see #getDartLikeExtensions()
   */
  public static boolean isDartLikeFileName(String fileName) {
    return isLikeFileName(fileName, getDartLikeExtensions());
  }

  /**
   * Return <code>true</code> if the given file name's extension is an HTML-like extension.
   * 
   * @param fileName the file name being tested
   * @return <code>true</code> if the given file name's extension is an HTML-like extension
   */
  public static boolean isHTMLLikeFileName(String fileName) {
    return isLikeFileName(fileName, HTML_FILE_EXTENSIONS);
  }

  /**
   * Return <code>true</code> if the given file name's extension is an image-like extension.
   * 
   * @param fileName the file name being tested
   * @return <code>true</code> if the given file name's extension is an image-like extension
   */
  public static boolean isImageLikeFileName(String fileName) {
    return isLikeFileName(fileName, IMAGE_FILE_EXTENSIONS);
  }

  /**
   * Return <code>true</code> if the given file name's extension is an HTML-like extension.
   * 
   * @param fileName the file name being tested
   * @return <code>true</code> if the given file name's extension is an HTML-like extension
   */
  public static boolean isJSLikeFileName(String fileName) {
    return isLikeFileName(fileName, JS_FILE_EXTENSIONS);
  }

  public static boolean isLinux() {
    return !isMac() && !isWindows();
  }

  public static boolean isMac() {
    // Look for the "Mac" OS name.
    return System.getProperty("os.name").toLowerCase().startsWith("mac");
  }

  /**
   * Return <code>true</code> if the given file name's extension is an HTML-like extension.
   * 
   * @param fileName the file name being tested
   * @return <code>true</code> if the given file name's extension is an HTML-like extension
   */
  public static boolean isTXTLikeFileName(String fileName) {
    return isLikeFileName(fileName, TXT_FILE_EXTENSIONS);
  }

  public static boolean isWindows() {
    // Look for the "Windows" OS name.
    return System.getProperty("os.name").toLowerCase().startsWith("win");
  }

  /**
   * Log the given message as an error.
   * 
   * @param message an explanation of why the error occurred or what it means
   */
  public static void logError(String message) {
    getPlugin().getLog().log(new Status(Status.ERROR, PLUGIN_ID, message, null));
  }

  /**
   * Log the given exception as one representing an error.
   * 
   * @param message an explanation of why the error occurred or what it means
   * @param exception the exception being logged
   */
  public static void logError(String message, Throwable exception) {
    getPlugin().getLog().log(new Status(Status.ERROR, PLUGIN_ID, message, exception));
  }

  /**
   * Log the given exception as one representing an error.
   * 
   * @param exception the exception being logged
   */
  public static void logError(Throwable exception) {
    getPlugin().getLog().log(new Status(Status.ERROR, PLUGIN_ID, exception.getMessage(), exception));
  }

  /**
   * Log the given informational message.
   * 
   * @param message an explanation of why the error occurred or what it means
   * @param exception the exception being logged
   */
  public static void logInformation(String message) {
    logInformation(message, null);
  }

  /**
   * Log the given exception as one representing an informational message.
   * 
   * @param message an explanation of why the error occurred or what it means
   * @param exception the exception being logged
   */
  public static void logInformation(String message, Throwable exception) {
    if (DartCoreDebug.VERBOSE) {
      getPlugin().getLog().log(new Status(Status.INFO, PLUGIN_ID, "INFO: " + message, exception));
    }
  }

  /**
   * This method exists as a convenient marker for methods that have not yet been fully implemented.
   * It should be deleted before this product ships.
   */
  public static void notYetImplemented() {
  }

  /**
   * If the given file defines a library, open the library and return it. If the library was already
   * open, then this method has no effect but returns the existing library. If the file does not
   * define a library, then look for a library in the same directory as the file or in a parent of
   * that directory that references the file. If such a library can be found, then open that library
   * and return it. Otherwise return <code>null</code>.
   * 
   * @param libraryFile the file defining the library to be opened
   * @param monitor the progress monitor used to provide feedback to the user, or <code>null</code>
   *          if no feedback is desired
   * @return the library defined by the given file
   * @throws DartModelException if the library exists but could not be opened for some reason
   */
  public static DartLibrary openLibrary(File libraryFile, IProgressMonitor monitor)
      throws DartModelException {
    return DartModelManager.getInstance().openLibrary(libraryFile, monitor);
  }

  /**
   * Removes the file extension from the given file name, if it has a Dart-like file extension.
   * Otherwise the file name itself is returned. Note this removes the dot ('.') before the
   * extension as well.
   * 
   * @param fileName the name of a file
   * @return the fileName without the Dart-like extension
   */
  public static String removeDartLikeExtension(String fileName) {
    return Util.getNameWithoutDartLikeExtension(fileName);
  }

  /**
   * Remove the given listener from the list of objects that are listening for changes to Dart
   * elements. Has no affect if an identical listener is not registered.
   * 
   * @param listener the listener to be removed
   */
  public static void removeElementChangedListener(ElementChangedListener listener) {
    DartModelManager.getInstance().removeElementChangedListener(listener);
  }

  /**
   * Runs the given action as an atomic Dart model operation.
   * <p>
   * After running a method that modifies Dart elements, registered listeners receive after-the-fact
   * notification of what just transpired, in the form of a element changed event. This method
   * allows clients to call a number of methods that modify Dart elements and only have element
   * changed event notifications reported at the end of the entire batch.
   * </p>
   * <p>
   * If this method is called outside the dynamic scope of another such call, this method runs the
   * action and then reports a single element changed event describing the net effect of all changes
   * done to Dart elements by the action.
   * </p>
   * <p>
   * If this method is called in the dynamic scope of another such call, this method simply runs the
   * action.
   * </p>
   * 
   * @param action the action to perform
   * @param monitor a progress monitor, or <code>null</code> if progress reporting and cancellation
   *          are not desired
   * @exception CoreException if the operation failed.
   */
  public static void run(IWorkspaceRunnable action, IProgressMonitor monitor) throws CoreException {
    run(action, ResourcesPlugin.getWorkspace().getRoot(), monitor);
  }

  /**
   * Runs the given action as an atomic Dart model operation.
   * <p>
   * After running a method that modifies Dart elements, registered listeners receive after-the-fact
   * notification of what just transpired, in the form of a element changed event. This method
   * allows clients to call a number of methods that modify Dart elements and only have element
   * changed event notifications reported at the end of the entire batch.
   * </p>
   * <p>
   * If this method is called outside the dynamic scope of another such call, this method runs the
   * action and then reports a single element changed event describing the net effect of all changes
   * done to Dart elements by the action.
   * </p>
   * <p>
   * If this method is called in the dynamic scope of another such call, this method simply runs the
   * action.
   * </p>
   * <p>
   * The supplied scheduling rule is used to determine whether this operation can be run
   * simultaneously with workspace changes in other threads. See <code>IWorkspace.run(...)</code>
   * for more details.
   * </p>
   * 
   * @param action the action to perform
   * @param rule the scheduling rule to use when running this operation, or <code>null</code> if
   *          there are no scheduling restrictions for this operation.
   * @param monitor a progress monitor, or <code>null</code> if progress reporting and cancellation
   *          are not desired
   * @exception CoreException if the operation failed.
   */
  public static void run(IWorkspaceRunnable action, ISchedulingRule rule, IProgressMonitor monitor)
      throws CoreException {
    IWorkspace workspace = ResourcesPlugin.getWorkspace();
    if (workspace.isTreeLocked()) {
      new BatchOperation(action).run(monitor);
    } else {
      // use IWorkspace.run(...) to ensure that a build will be done in
// autobuild mode
      workspace.run(new BatchOperation(action), rule, IWorkspace.AVOID_UPDATE, monitor);
    }
  }

  public static void setOptions(HashMap<String, String> newOptions) {
    DartModelManager.getInstance().setOptions(new Hashtable<String, String>(newOptions));
  }

  /**
   * Sets the current table of options. All and only the options explicitly included in the given
   * table are remembered; all previous option settings are forgotten, including ones not explicitly
   * mentioned.
   * <p>
   * Helper constants have been defined on DartPreferenceConstants for each of the option IDs
   * (categorized in Code assist option ID, Compiler option ID and Core option ID) and some of their
   * acceptable values (categorized in Option value). Some options accept open value sets beyond the
   * documented constant values.
   * <p>
   * Note: each release may add new options.
   * 
   * @param newOptions the new options, or <code>null</code> to reset all options to their default
   *          values
   */
  public static void setOptions(Hashtable<String, String> newOptions) {
    DartModelManager.getInstance().setOptions(newOptions);
  }

  /**
   * Return <code>true</code> if the given file name's extension matches one of the passed
   * extensions.
   * 
   * @param fileName the file name being tested
   * @param extensions an array of file extensions to test against
   * @return <code>true</code> if the given file name's extension matches one of the passed
   *         extensions
   */
  private static boolean isLikeFileName(String fileName, String[] extensions) {
    if (fileName == null || fileName.length() == 0) {
      return false;
    }
    for (String extension : extensions) {
      if (StringUtilities.endsWithIgnoreCase(fileName, '.' + extension)) {
        return true;
      }
    }
    return false;
  }

  private IEclipsePreferences prefs;

  /**
   * Initialize a newly created instance of this class.
   */
  public DartCore() {
    PLUG_IN = this;
  }

  /**
   * Use frog if sdk is present
   */
  public boolean getCompileWithFrog() {
    return DartSdk.isInstalled();
  }

  /**
   * Return the package root preference
   */
  public String getPackageRootPref() {
    String pref = DartCore.getPlugin().getPrefs().get(DartCore.PACKAGE_ROOT_DIR_PREFERENCE, null);

    if (pref != null && pref.length() == 0) {
      return null;
    } else {
      return pref;
    }
  }

  public IEclipsePreferences getPrefs() {
    if (prefs == null) {
      prefs = InstanceScope.INSTANCE.getNode(PLUGIN_ID);
    }

    return prefs;
  }

  @Override
  public void start(BundleContext context) throws Exception {
    super.start(context);
  }

  @Override
  public void stop(BundleContext context) throws Exception {
    try {
      AnalysisIndexManager.stopServerAndIndexing();
      DartModelManager.shutdown();
      RootArtifactProvider.shutdown();
      FrogManager.shutdown();

      if (DartCoreDebug.METRICS) {
        StringWriter writer = new StringWriter();
        PerformanceManager.getInstance().printMetrics(new PrintWriter(writer));
        String metricsInfo = writer.toString();
        if (metricsInfo.length() > 0) {
          getLog().log(new Status(Status.INFO, PLUGIN_ID, metricsInfo, null));
        }
      }
    } finally {
      super.stop(context);
    }
  }
}
