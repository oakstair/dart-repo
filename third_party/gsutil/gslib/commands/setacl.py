# Copyright 2011 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

from gslib.command import Command
from gslib.command import COMMAND_NAME
from gslib.command import COMMAND_NAME_ALIASES
from gslib.command import CONFIG_REQUIRED
from gslib.command import FILE_URIS_OK
from gslib.command import MAX_ARGS
from gslib.command import MIN_ARGS
from gslib.command import PROVIDER_URIS_OK
from gslib.command import SUPPORTED_SUB_ARGS
from gslib.command import URIS_START_ARG
from gslib.help_provider import HELP_NAME
from gslib.help_provider import HELP_NAME_ALIASES
from gslib.help_provider import HELP_ONE_LINE_SUMMARY
from gslib.help_provider import HELP_TEXT
from gslib.help_provider import HelpType
from gslib.help_provider import HELP_TYPE
from gslib.util import NO_MAX

_detailed_help_text = ("""
<B>SYNOPSIS</B>
  gsutil setacl [-R] file-or-canned_acl_name uri...


<B>DESCRIPTION</B>
  The setacl command allows you to set an Access Control List on one or
  more buckets and objects. The simplest way to use it is to specify one of
  the canned ACLs, e.g.,:

    gsutil setacl private gs://bucket

  or:

    gsutil setacl public-read gs://bucket/object

  See "gsutil help acls" for a list of all canned ACLs.

  If you want to define more fine-grained control over your data, you can
  retrieve an ACL using the getacl command (see "gsutil help getacl"),
  save the output to a file, edit the file, and then use the gsutil setacl
  command to set that ACL on the buckets and/or objects. For example:

    gsutil getacl gs://bucket/file.txt > acl.txt
    (Make changes to acl.txt such as adding an additional grant.)
    gsutil setacl acl.txt gs://cats/file.txt

  Note that you can set an ACL on multiple buckets or objects at once,
  for example:

    gsutil setacl acl.txt gs://bucket/*.jpg

  If you have a large number of ACLs to update you might want to use the
  gsutil -m option, to perform a parallel (multi-threaded/multi-processing)
  updates:

    gsutil -m setacl acl.txt gs://bucket/*.jpg

  Note that multi-threading/multi-processing is only done when the named URIs
  refer to objects. gsutil -m setacl gs://bucket1 gs://bucket2 will run the
  setacl operations sequentially.


<B>OPTIONS</B>
  -R, -r      Performs setacl request recursively, to all objects under the
              specified URI.
""")


class SetAclCommand(Command):
  """Implementation of gsutil setacl command."""

  # Command specification (processed by parent class).
  command_spec = {
    # Name of command.
    COMMAND_NAME : 'setacl',
    # List of command name aliases.
    COMMAND_NAME_ALIASES : [],
    # Min number of args required by this command.
    MIN_ARGS : 2,
    # Max number of args required by this command, or NO_MAX.
    MAX_ARGS : NO_MAX,
    # Getopt-style string specifying acceptable sub args.
    SUPPORTED_SUB_ARGS : 'Rr',
    # True if file URIs acceptable for this command.
    FILE_URIS_OK : False,
    # True if provider-only URIs acceptable for this command.
    PROVIDER_URIS_OK : False,
    # Index in args of first URI arg.
    URIS_START_ARG : 1,
    # True if must configure gsutil before running command.
    CONFIG_REQUIRED : True,
  }
  help_spec = {
    # Name of command or auxiliary help info for which this help applies.
    HELP_NAME : 'setacl',
    # List of help name aliases.
    HELP_NAME_ALIASES : [],
    # Type of help:
    HELP_TYPE : HelpType.COMMAND_HELP,
    # One line summary of this help.
    HELP_ONE_LINE_SUMMARY : 'Set ACLs on buckets and/or objects',
    # The full help text.
    HELP_TEXT : _detailed_help_text,
  }

  # Command entry point.
  def RunCommand(self):
    if self.sub_opts:
      for o, unused_a in self.sub_opts:
        if o == '-r' or o == '-R':
          self.recursion_requested = True
    self.SetAclCommandHelper()
