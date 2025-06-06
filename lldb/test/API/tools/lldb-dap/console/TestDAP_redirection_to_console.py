import dap_server
import json
from lldbsuite.test.decorators import *
from lldbsuite.test.lldbtest import *
from lldbsuite.test import lldbutil
import lldbdap_testcase


class TestDAP_redirection_to_console(lldbdap_testcase.DAPTestCaseBase):
    def test(self):
        """
        Without proper stderr and stdout redirection, the following code would throw an
        exception, like the following:

            Exception: unexpected malformed message from lldb-dap
        """
        program = self.getBuildArtifact("a.out")
        self.build_and_launch(
            program, adapter_env={"LLDB_DAP_TEST_STDOUT_STDERR_REDIRECTION": "1"}
        )

        source = "main.cpp"

        breakpoint1_line = line_number(source, "// breakpoint 1")
        breakpoint_ids = self.set_source_breakpoints(source, [breakpoint1_line])

        self.assertEqual(len(breakpoint_ids), 1, "expect correct number of breakpoints")
        self.continue_to_breakpoints(breakpoint_ids)

        self.assertIn(
            "argc", json.dumps(self.dap_server.get_local_variables(frameIndex=1))
        )
