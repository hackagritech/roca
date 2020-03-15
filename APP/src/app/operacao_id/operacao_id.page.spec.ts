import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { IonicModule } from '@ionic/angular';
import { ExploreContainerComponentModule } from '../explore-container/explore-container.module';

import { OperacaoIdPage } from './operacao_id.page';

describe('OperacaoId', () => {
  let component: OperacaoIdPage;
  let fixture: ComponentFixture<OperacaoIdPage>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [OperacaoIdPage],
      imports: [IonicModule.forRoot(), ExploreContainerComponentModule]
    }).compileComponents();

    fixture = TestBed.createComponent(OperacaoIdPage);
    component = fixture.componentInstance;
    fixture.detectChanges();
  }));

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
