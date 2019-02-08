
OpenDSSDirect.Text.Command("clear")

dir = init8500()

OpenDSSDirect.Text.Command("""
    New Energymeter.m1 Line.ln5815900-1 1
    set mode=yearly number=2
    solve
    Redirect $(joinpath(dir, "Fuses.dss"))
""")

@testset "Meters" begin

@test Meters.First() == 1
@test Meters.Next() == 0
@test Meters.Reset() == nothing
@test Meters.ResetAll() == nothing
@test Meters.Sample() == nothing
@test Meters.Save() == nothing
@test Meters.MeteredTerminal() == 1
@test Meters.MeteredTerminal(Meters.MeteredTerminal()) == nothing
@test Meters.DIFilesAreOpen() == 0
if typeof(1) == Int64
    @test_broken Meters.SampleAll() == 0    # TODO: segfault
    @test_broken Meters.CountEndElements() == 0    # TODO: segfault
    @test_broken Meters.AllEndElements()    # TODO: segfaults
    @test_broken Meters.AllBranchesInZone()    # TODO: segfaults
end
@test Meters.SaveAll() == nothing
@test Meters.OpenAllDIFiles() == nothing
@test Meters.CloseAllDIFiles() == nothing
@test Meters.Count() == 1
@test Meters.CountBranches() == 4881
@test Meters.SequenceList() == 1
@test Meters.SequenceList(Meters.SequenceList()) == nothing
if !( Sys.iswindows() && typeof(1) != Int64 )
    # Does not Segfaults on all platforms except Windows x86
    @test Meters.DoReliabilityCalc(false) == nothing
    # Following results if DoReliabilityCalc(false) is called
    @test Meters.TotalCustomers() == 1177
    @test Meters.NumSections() == 30
    @test Meters.SetActiveSection(1) == nothing
    @test Meters.OCPDeviceType() == 1
    @test Meters.NumSectionCustomers() == 28
    @test Meters.NumSectionBranches() == 105
    @test Meters.SectSeqidx() == 21
    @test Meters.SectTotalCust() == 28
    @test Meters.SAIFI() ≋ 9.875348385699192
    @test Meters.SAIFIkW() ≋ 9.171172946672693
    @test Meters.SAIDI() ≋ 29.62604515709752
    @test Meters.CustInterrupts() ≋ 11623.28504996795
    @test Meters.AvgRepairTime() ≋ 2.9999999999999987
    @test Meters.FaultRateXRepairHrs() ≋ 2372.91137653651
    @test Meters.SumBranchFltRates() ≋ 790.9704588455037
else
    # TODO: Segfaults on Windows x86
    @test_skip Meters.DoReliabilityCalc(false) == nothing
    # Following results if DoReliabilityCalc(false) is not called
    @test Meters.TotalCustomers() == 0
    @test Meters.NumSections() == 0
    @test Meters.SetActiveSection(1) == nothing
    @test Meters.OCPDeviceType() == 0
    @test Meters.NumSectionCustomers() == 0
    @test Meters.NumSectionBranches() == 0
    @test Meters.SectSeqidx() == 0
    @test Meters.SectTotalCust() == 0
    @test Meters.SAIFI() ≋ 0
    @test Meters.SAIFIkW() ≋ 0
    @test Meters.SAIDI() ≋ 0
    @test Meters.CustInterrupts() ≋ 0
    @test Meters.AvgRepairTime() ≋ 0
    @test Meters.FaultRateXRepairHrs() ≋ 0
    @test Meters.SumBranchFltRates() ≋ 0
end
@test Meters.SeqListSize() == 4881
@test Meters.Name() == "m1"
@test Meters.Name(Meters.Name()) == nothing
@test Meters.MeteredElement() == "line.ln5815900-1"
@test Meters.MeteredElement(Meters.MeteredElement()) == nothing
@test Meters.AllNames()[1] == "m1"
@test Meters.RegisterNames()[1] == "kWh"
# @test Meters.RegisterValues(Meters.RegisterValues()) == nothing # TODO: implement setter?
@test Meters.Totals()[1] ≋ 11915.293117698093
@test Meters.PeakCurrent()[1] ≋ 400.0
@test Meters.PeakCurrent(Meters.PeakCurrent()) == nothing
@test 1 + Meters.CalcCurrent()[1] ≋ 1 + 0.0
@test Meters.CalcCurrent(Meters.CalcCurrent()) == nothing
@test 1 + Meters.AllocFactors()[1] ≋ 1 + 0.0
@test Meters.AllocFactors(Meters.AllocFactors()) == nothing

end # testset
