package org.firstinspires.ftc.teamcode

import com.pedropathing.api.Paths.*
import com.pedropathing.api.Paths
import com.pedropathing.api.PoseFactory
import com.pedropathing.follower.Follower
import com.pedropathing.math.Pose
import com.pedropathing.paths.Path
import com.pedropathing.ivy.Command
import com.pedropathing.ivy.Scheduler
import com.pedropathing.ivy.Scheduler.schedule
import com.pedropathing.ivy.commands.Commands.*
import com.pedropathing.ivy.groups.Groups.sequential
import com.pedropathing.ivy.pedro.PedroCommands.follow
import com.qualcomm.robotcore.eventloop.opmode.Autonomous
import com.qualcomm.robotcore.eventloop.opmode.LinearOpMode
import org.firstinspires.ftc.teamcode.pedro.Constants

@Autonomous(name = "AutoPath", group = "Autonomous")
class AutoPath : LinearOpMode() {

    private lateinit var follower: Follower

    private val poseFactory = PoseFactory.degrees()

    private val start = poseFactory.of(56.0, 8.0, 90.0)
    private val path1 = poseFactory.of(115.2851, 22.0995, 13.3779)
    private val point2 = poseFactory.of(126.31, 124.027, 83.8266)
    private val point3 = poseFactory.of(22.5752, 109.0311, -171.7743)
    private val point4 = poseFactory.of(6.435, 57.1747, -107.2886)
    private val point5 = poseFactory.of(49.7007, 45.1767, -15.4992)
    private val point6 = poseFactory.of(58.2155, 9.8016, -76.4664)

    // Autonomous routine
    fun autoRoutine(): Command = sequential(
        follow(follower, path1()),
        follow(follower, path2()),
        follow(follower, path3()),
        follow(follower, path4()),
        follow(follower, path5()),
        follow(follower, path6())
    )

    override fun runOpMode() {
        Scheduler.reset()
        follower = Constants.create(hardwareMap)
        follower.setPose(start)
        follower.update()

        waitForStart()
        schedule(autoRoutine())

        while (opModeIsActive()) {
            follower.update()
            Scheduler.execute()

            telemetry.addData("x", follower.pose().x())
            telemetry.addData("y", follower.pose().y())
            telemetry.addData("heading", follower.pose().heading())

            if (follower.currentPath() != null) {
                telemetry.addData("Current path distance remaining", follower.distanceToEndpoint())
                telemetry.addData("Path number", follower.pathIndex())
            }

            telemetry.update()
        }
    }

    fun path1(): Path = Paths.line(start, path1).tangent()

    fun path2(): Path = Paths.line(path1, point2).tangent()

    fun path3(): Path = Paths.line(point2, point3).tangent()

    fun path4(): Path = Paths.line(point3, point4).tangent()

    fun path5(): Path = Paths.line(point4, point5).tangent()

    fun path6(): Path = Paths.line(point5, point6).tangent()
}
