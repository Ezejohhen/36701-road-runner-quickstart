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

@Autonomous(name = "AutoPath", group = "Autonomous")
class AutoPath : LinearOpMode() {

    private lateinit var follower: Follower

    private val poseFactory = PoseFactory.degrees()

    private val start = poseFactory.of(56.0, 8.0, 90.0)
    private val path1 = poseFactory.of(115.2851, 22.0995, 13.3779)
    private val point2 = poseFactory.of(126.3066, 124.027, -96.1715)
    private val point3 = poseFactory.of(22.5752, 109.0311, 8.2259)
    private val point4 = poseFactory.of(6.435, 57.1747, 72.7114)
    private val point5 = poseFactory.of(56.7104, 42.6817, 163.9193)
    private val point6 = poseFactory.of(58.2155, 9.8016, 92.6209)

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

    fun path2(): Path = Paths.line(path1, point2).reverseTangent()

    fun path3(): Path = Paths.line(point2, point3).reverseTangent()

    fun path4(): Path = Paths.line(point3, point4).reverseTangent()

    fun path5(): Path = Paths.line(point4, point5).reverseTangent()

    fun path6(): Path = Paths.line(point5, point6).reverseTangent()
}